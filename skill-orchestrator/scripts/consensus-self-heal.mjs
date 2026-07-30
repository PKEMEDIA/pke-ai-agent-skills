#!/usr/bin/env node
/**
 * Distributed Consensus Self-Heal Engine (Raft-lite)
 * COVICEA × PKE / skill-orchestrator
 *
 * Phases: PROBE → PROPOSE → VOTE → LEASE → COMMIT → VERIFY → RELEASE
 *
 * Usage:
 *   node consensus-self-heal.mjs              # unit suite + demo
 *   node consensus-self-heal.mjs --demo       # demo only
 *   node consensus-self-heal.mjs --json       # JSON summary
 */

import { createHash, randomUUID } from "node:crypto";
import { mkdirSync, writeFileSync, readFileSync, existsSync, unlinkSync } from "node:fs";
import { join } from "node:path";

export function majority(n) {
  return Math.floor(n / 2) + 1;
}

export function quorumReached(votes, n, required = majority(n)) {
  return votes.filter((v) => v.decision === "ACK").length >= required;
}

export const DEFAULT_VOTERS = [
  { id: "skill-orchestrator", role: "coordinator", health: "online", epoch: 1, lastSeen: 0 },
  { id: "MediaCurator", role: "specialist", health: "online", epoch: 1, lastSeen: 0 },
  { id: "Compilation-Builder", role: "specialist", health: "online", epoch: 1, lastSeen: 0 },
  { id: "edge-sync", role: "edge", health: "online", epoch: 1, lastSeen: 0 },
  { id: "skill-test-suite", role: "validator", health: "online", epoch: 1, lastSeen: 0 },
];

const LEASE_TTL_MS = 60_000;
const PROPOSAL_TTL_MS = 30_000;

export class ConsensusSelfHeal {
  constructor(opts = {}) {
    this.voters = structuredClone(opts.voters ?? DEFAULT_VOTERS);
    this.leaseDir = opts.leaseDir ?? join(process.cwd(), "artifacts", "heal-leases");
    this.now = opts.now ?? (() => Date.now());
    this.executor = opts.executor ?? (async (p) => `executed:${p.action}@${p.target}`);
    this.state = {
      phase: "PROBE",
      proposal: null,
      votes: [],
      lease: null,
      commitResult: null,
      verifyOk: null,
      log: [],
    };
    mkdirSync(this.leaseDir, { recursive: true });
  }

  log(msg) {
    const line = `[${new Date(this.now()).toISOString()}] ${msg}`;
    this.state.log.push(line);
    return line;
  }

  setPhase(phase) {
    this.state.phase = phase;
    this.log(`phase=${phase}`);
  }

  probe() {
    this.setPhase("PROBE");
    const report = {};
    for (const v of this.voters) {
      v.lastSeen = this.now();
      report[v.id] = v.health;
    }
    this.log(
      `probe voters=${this.voters.length} offline=${this.voters.filter((v) => v.health === "offline").length}`,
    );
    return report;
  }

  propose(input) {
    this.setPhase("PROPOSE");
    const proposer = this.voters.find((v) => v.id === input.proposerId);
    if (!proposer) {
      this.setPhase("ABORTED");
      this.log(`abort: unknown proposer ${input.proposerId}`);
      return null;
    }
    if (proposer.health === "offline") {
      this.setPhase("ABORTED");
      this.log("abort: proposer offline");
      return null;
    }

    const existing = this.readLeaseFile(input.target);
    if (existing && existing.expiresAt > this.now() && existing.holderId !== input.proposerId) {
      this.setPhase("ABORTED");
      this.log(`abort: lease held by ${existing.holderId} until ${existing.expiresAt}`);
      return null;
    }

    const maxEpoch = Math.max(...this.voters.map((v) => v.epoch), 1);
    const proposal = {
      target: input.target,
      action: input.action,
      evidence: input.evidence,
      epoch: maxEpoch,
      proposerId: input.proposerId,
      proposalId: randomUUID(),
      ts: this.now(),
    };
    this.state.proposal = proposal;
    this.state.votes = [];
    this.log(
      `propose id=${proposal.proposalId} target=${proposal.target} action=${proposal.action} epoch=${proposal.epoch}`,
    );
    return proposal;
  }

  vote(observeFn) {
    this.setPhase("VOTE");
    const proposal = this.state.proposal;
    if (!proposal) {
      this.setPhase("ABORTED");
      this.log("abort: no proposal");
      return [];
    }
    if (this.now() - proposal.ts > PROPOSAL_TTL_MS) {
      this.setPhase("ABORTED");
      this.log("abort: proposal expired");
      return [];
    }

    const defaultObserve = (voter, p) => {
      if (voter.health === "offline") return false;
      if (voter.id === p.proposerId) return true;
      if (voter.role === "coordinator") return true;
      if (p.evidence.includes(voter.id)) return true;
      return /offline|degraded|down|fail/i.test(p.evidence);
    };
    const observe = observeFn ?? defaultObserve;

    const votes = [];
    for (const voter of this.voters) {
      const ok = observe(voter, proposal);
      votes.push({
        voterId: voter.id,
        proposalId: proposal.proposalId,
        decision: ok ? "ACK" : "NACK",
        reason: ok
          ? "evidence-match"
          : voter.health === "offline"
            ? "voter-offline"
            : "no-evidence",
        ts: this.now(),
      });
    }
    this.state.votes = votes;
    const acks = votes.filter((v) => v.decision === "ACK").length;
    this.log(`vote acks=${acks}/${votes.length} need=${majority(this.voters.length)}`);
    return votes;
  }

  acquireLease() {
    this.setPhase("LEASE");
    const proposal = this.state.proposal;
    if (!proposal) {
      this.setPhase("ABORTED");
      return null;
    }
    if (!quorumReached(this.state.votes, this.voters.length)) {
      this.setPhase("ABORTED");
      this.log("abort: quorum not reached");
      return null;
    }

    const existing = this.readLeaseFile(proposal.target);
    if (existing && existing.expiresAt > this.now() && existing.holderId !== proposal.proposerId) {
      this.setPhase("ABORTED");
      this.log(`abort: race lost to ${existing.holderId}`);
      return null;
    }

    const lease = {
      proposalId: proposal.proposalId,
      holderId: proposal.proposerId,
      epoch: proposal.epoch,
      expiresAt: this.now() + LEASE_TTL_MS,
      target: proposal.target,
    };
    this.writeLeaseFile(lease);
    this.state.lease = lease;
    this.log(`lease acquired holder=${lease.holderId} expires=${lease.expiresAt}`);
    return lease;
  }

  async commit() {
    this.setPhase("COMMIT");
    const proposal = this.state.proposal;
    const lease = this.state.lease;
    if (!proposal || !lease) {
      this.setPhase("ABORTED");
      this.log("abort: missing proposal or lease");
      return null;
    }
    if (lease.expiresAt < this.now()) {
      this.setPhase("ABORTED");
      this.log("abort: lease expired before commit");
      return null;
    }
    if (lease.holderId !== proposal.proposerId) {
      this.setPhase("ABORTED");
      this.log("abort: lease holder mismatch");
      return null;
    }

    const result = await this.executor(proposal);
    this.state.commitResult = result;
    this.log(`commit ${result}`);
    return result;
  }

  verify(recoverFn) {
    this.setPhase("VERIFY");
    if (recoverFn) recoverFn(this.voters);
    if (this.state.commitResult && !recoverFn) {
      for (const v of this.voters) {
        if (v.health === "offline" || v.health === "degraded") {
          v.health = "online";
          v.epoch += 1;
        }
      }
    }
    const offline = this.voters.filter((v) => v.health === "offline").length;
    this.state.verifyOk = offline === 0;
    this.log(`verify offline=${offline} ok=${this.state.verifyOk}`);
    return this.state.verifyOk;
  }

  release() {
    this.setPhase("RELEASE");
    if (this.state.lease) {
      this.clearLeaseFile(this.state.lease.target);
      this.log(`lease released target=${this.state.lease.target}`);
      this.state.lease = null;
    }
    this.setPhase("DONE");
    return true;
  }

  async run(input) {
    this.probe();
    const proposal = this.propose(input);
    if (!proposal) return this.summary();
    this.vote();
    if (!this.acquireLease()) return this.summary();
    await this.commit();
    this.verify();
    this.release();
    return this.summary();
  }

  summary() {
    return {
      phase: this.state.phase,
      proposalId: this.state.proposal?.proposalId ?? null,
      target: this.state.proposal?.target ?? null,
      action: this.state.proposal?.action ?? null,
      votes: this.state.votes.map((v) => ({ id: v.voterId, decision: v.decision })),
      quorum: this.state.votes.length
        ? quorumReached(this.state.votes, this.voters.length)
        : false,
      leaseHolder: this.state.lease?.holderId ?? null,
      commitResult: this.state.commitResult,
      verifyOk: this.state.verifyOk,
      log: this.state.log,
    };
  }

  leasePath(target) {
    const safe = createHash("sha1").update(target).digest("hex").slice(0, 12);
    return join(this.leaseDir, `lease-${safe}.json`);
  }

  readLeaseFile(target) {
    const p = this.leasePath(target);
    if (!existsSync(p)) return null;
    try {
      const data = JSON.parse(readFileSync(p, "utf8"));
      if (data.expiresAt < this.now()) {
        unlinkSync(p);
        return null;
      }
      return data;
    } catch {
      return null;
    }
  }

  writeLeaseFile(lease) {
    writeFileSync(this.leasePath(lease.target), JSON.stringify(lease, null, 2));
  }

  clearLeaseFile(target) {
    const p = this.leasePath(target);
    if (existsSync(p)) unlinkSync(p);
  }
}

function assert(cond, msg) {
  if (!cond) throw new Error(`FAIL: ${msg}`);
}

export async function runTests() {
  const results = [];
  const t = async (name, fn) => {
    try {
      await fn();
      results.push({ name, ok: true });
    } catch (e) {
      results.push({ name, ok: false, error: String(e.message || e) });
    }
  };

  await t("majority math", () => {
    assert(majority(1) === 1, "n=1");
    assert(majority(2) === 2, "n=2");
    assert(majority(3) === 2, "n=3");
    assert(majority(5) === 3, "n=5");
    assert(majority(7) === 4, "n=7");
  });

  await t("happy path: offline service heals with quorum", async () => {
    const engine = new ConsensusSelfHeal({
      leaseDir: join(process.cwd(), "artifacts", "heal-leases-test-ok"),
    });
    engine.voters[1].health = "offline";
    const summary = await engine.run({
      proposerId: "skill-orchestrator",
      target: "MediaCurator",
      action: "restart",
      evidence: "MediaCurator offline latency=-1",
    });
    assert(summary.phase === "DONE", `phase=${summary.phase}`);
    assert(summary.quorum === true, "quorum");
    assert(summary.verifyOk === true, "verify");
    assert(summary.commitResult?.startsWith("executed:"), "commit");
  });

  await t("split-brain: second proposer loses lease race", async () => {
    const dir = join(process.cwd(), "artifacts", "heal-leases-test-race");
    const a = new ConsensusSelfHeal({ leaseDir: dir });
    const b = new ConsensusSelfHeal({ leaseDir: dir });
    a.voters[2].health = "offline";
    b.voters[2].health = "offline";

    a.probe();
    a.propose({
      proposerId: "skill-orchestrator",
      target: "Compilation-Builder",
      action: "restart",
      evidence: "Compilation-Builder offline",
    });
    a.vote();
    const leaseA = a.acquireLease();
    assert(leaseA, "A got lease");

    b.probe();
    b.propose({
      proposerId: "MediaCurator",
      target: "Compilation-Builder",
      action: "restart",
      evidence: "Compilation-Builder offline",
    });
    assert(b.state.phase === "ABORTED", `B phase should abort, got ${b.state.phase}`);
    a.release();
  });

  await t("no quorum when most voters offline", async () => {
    const engine = new ConsensusSelfHeal({
      leaseDir: join(process.cwd(), "artifacts", "heal-leases-test-noq"),
    });
    engine.voters[1].health = "offline";
    engine.voters[2].health = "offline";
    engine.voters[3].health = "offline";
    engine.probe();
    engine.propose({
      proposerId: "skill-orchestrator",
      target: "edge-sync",
      action: "reconnect",
      evidence: "edge-sync degraded",
    });
    engine.vote((voter) => voter.health === "online" && voter.role === "coordinator");
    assert(!quorumReached(engine.state.votes, engine.voters.length), "should lack quorum");
    const lease = engine.acquireLease();
    assert(lease === null, "no lease without quorum");
    assert(engine.state.phase === "ABORTED", "aborted");
  });

  await t("stale proposal expires", async () => {
    let fakeNow = 1_000_000;
    const engine = new ConsensusSelfHeal({
      leaseDir: join(process.cwd(), "artifacts", "heal-leases-test-ttl"),
      now: () => fakeNow,
    });
    engine.propose({
      proposerId: "skill-orchestrator",
      target: "x",
      action: "restart",
      evidence: "offline",
    });
    fakeNow += PROPOSAL_TTL_MS + 1;
    engine.vote();
    assert(engine.state.phase === "ABORTED", "expired proposal aborted");
  });

  await t("unknown proposer rejected", async () => {
    const engine = new ConsensusSelfHeal({
      leaseDir: join(process.cwd(), "artifacts", "heal-leases-test-unk"),
    });
    const p = engine.propose({
      proposerId: "ghost-node",
      target: "x",
      action: "restart",
      evidence: "offline",
    });
    assert(p === null, "null proposal");
    assert(engine.state.phase === "ABORTED", "aborted");
  });

  return results;
}

async function main() {
  const args = process.argv.slice(2);
  const jsonOnly = args.includes("--json");
  const demoOnly = args.includes("--demo");

  let testResults = [];
  if (!demoOnly) {
    testResults = await runTests();
    const failed = testResults.filter((r) => !r.ok);
    if (!jsonOnly) {
      console.log("=== Consensus Self-Heal Unit Tests ===");
      for (const r of testResults) {
        console.log(`${r.ok ? "PASS" : "FAIL"}  ${r.name}${r.error ? " — " + r.error : ""}`);
      }
      console.log(`Result: ${testResults.length - failed.length}/${testResults.length} passed`);
    }
    if (failed.length) {
      if (jsonOnly) console.log(JSON.stringify({ ok: false, tests: testResults }, null, 2));
      process.exit(1);
    }
  }

  const engine = new ConsensusSelfHeal({
    leaseDir: join(process.cwd(), "artifacts", "heal-leases"),
  });
  engine.voters[1].health = "offline";
  engine.voters[3].health = "degraded";
  const summary = await engine.run({
    proposerId: "skill-orchestrator",
    target: "MediaCurator",
    action: "restart+edge-resync",
    evidence: "MediaCurator offline · edge-sync degraded",
  });

  if (jsonOnly) {
    console.log(JSON.stringify({ ok: true, tests: testResults, demo: summary }, null, 2));
  } else {
    console.log("\n=== Demo: heal MediaCurator via consensus ===");
    console.log(`phase=${summary.phase} quorum=${summary.quorum} verify=${summary.verifyOk}`);
    console.log(`commit=${summary.commitResult}`);
    console.log("votes:", summary.votes.map((v) => `${v.id}:${v.decision}`).join(" "));
  }
}

const isMain =
  process.argv[1] &&
  (process.argv[1].endsWith("consensus-self-heal.mjs") ||
    process.argv[1].includes("consensus-self-heal"));

if (isMain) {
  main().catch((e) => {
    console.error(e);
    process.exit(1);
  });
}
