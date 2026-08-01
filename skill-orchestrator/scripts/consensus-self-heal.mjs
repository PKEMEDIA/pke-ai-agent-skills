#!/usr/bin/env node
/**
 * Distributed Consensus Self-Heal Engine (Raft-lite) + Idempotency
 * COVICEA × PKE / skill-orchestrator
 *
 * Phases: PROBE → PROPOSE → VOTE → LEASE → COMMIT → VERIFY → RELEASE
 *
 * Idempotency safeguards (heal-safe under lease-expiry retry):
 *   1. Pre-commit cooldown check — active ok stamp → SKIP (no-op success)
 *   2. Pre-commit health probe — target already healthy → SKIP + stamp
 *   3. Post-verify success stamp — fingerprint + cooldownUntil
 *   4. Failed stamp — short cooldown, does not claim success
 *   5. force:true bypasses cooldown (operator override only)
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

/** Stable action key for stamp files: sha1(target|action)[:12] */
export function actionKey(target, action) {
  return createHash("sha1").update(`${target}|${action}`).digest("hex").slice(0, 12);
}

/** Content fingerprint for a proposal (evidence + action + target). */
export function healFingerprint(proposal) {
  const raw = `${proposal.target}|${proposal.action}|${proposal.evidence || ""}`;
  return createHash("sha1").update(raw).digest("hex").slice(0, 16);
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
/** Soft heals (reconnect, cross-ref) */
export const COOLDOWN_SOFT_MS = 60_000;
/** Destructive heals (restart, archive, bulk rewrite, push) */
export const COOLDOWN_DESTRUCTIVE_MS = 120_000;
/** Failed heals — brief back-off only */
export const COOLDOWN_FAILED_MS = 30_000;

const DESTRUCTIVE_RE = /restart|archive|bulk|rewrite|push|delete|wipe|force/i;

export function cooldownFor(action, status = "ok") {
  if (status === "failed") return COOLDOWN_FAILED_MS;
  if (DESTRUCTIVE_RE.test(action || "")) return COOLDOWN_DESTRUCTIVE_MS;
  return COOLDOWN_SOFT_MS;
}

/**
 * File-backed heal stamp registry.
 * Path: <stampDir>/stamp-<actionKey>.json
 */
export class HealStampStore {
  constructor(opts = {}) {
    this.stampDir = opts.stampDir ?? join(process.cwd(), "artifacts", "heal-stamps");
    this.now = opts.now ?? (() => Date.now());
    mkdirSync(this.stampDir, { recursive: true });
  }

  pathFor(target, action) {
    return join(this.stampDir, `stamp-${actionKey(target, action)}.json`);
  }

  read(target, action) {
    const p = this.pathFor(target, action);
    if (!existsSync(p)) return null;
    try {
      return JSON.parse(readFileSync(p, "utf8"));
    } catch {
      return null;
    }
  }

  /**
   * Returns { skip: true, reason, stamp } when a prior ok heal is still in cooldown
   * and (optionally) fingerprint matches. force bypasses.
   */
  shouldSkip(target, action, { force = false, fingerprint = null } = {}) {
    if (force) return { skip: false, reason: "force" };
    const stamp = this.read(target, action);
    if (!stamp) return { skip: false, reason: "no-stamp" };
    const now = this.now();
    if (stamp.status !== "ok" && stamp.status !== "skipped_already_healthy") {
      return { skip: false, reason: "prior-failed", stamp };
    }
    if (stamp.cooldownUntil && stamp.cooldownUntil > now) {
      // Fingerprint match or absent fingerprint → safe skip
      if (!fingerprint || !stamp.fingerprint || stamp.fingerprint === fingerprint) {
        return {
          skip: true,
          reason: "cooldown-active",
          stamp,
          remainingMs: stamp.cooldownUntil - now,
        };
      }
      // Different evidence/fingerprint — allow re-heal
      return { skip: false, reason: "fingerprint-changed", stamp };
    }
    return { skip: false, reason: "cooldown-expired", stamp };
  }

  write(record) {
    const target = record.target;
    const action = record.action;
    const path = this.pathFor(target, action);
    const payload = {
      target,
      action,
      fingerprint: record.fingerprint ?? null,
      status: record.status ?? "ok",
      holderId: record.holderId ?? null,
      proposalId: record.proposalId ?? null,
      epoch: record.epoch ?? 0,
      completedAt: record.completedAt ?? this.now(),
      cooldownUntil:
        record.cooldownUntil ??
        this.now() + cooldownFor(action, record.status ?? "ok"),
      result: record.result ?? null,
    };
    writeFileSync(path, JSON.stringify(payload, null, 2));
    return payload;
  }

  clear(target, action) {
    const p = this.pathFor(target, action);
    if (existsSync(p)) unlinkSync(p);
  }
}

export class ConsensusSelfHeal {
  constructor(opts = {}) {
    this.voters = structuredClone(opts.voters ?? DEFAULT_VOTERS);
    this.leaseDir = opts.leaseDir ?? join(process.cwd(), "artifacts", "heal-leases");
    this.stampDir = opts.stampDir ?? join(process.cwd(), "artifacts", "heal-stamps");
    this.now = opts.now ?? (() => Date.now());
    this.executor = opts.executor ?? (async (p) => `executed:${p.action}@${p.target}`);
    /** Optional: (target) => boolean — true if target is already healthy */
    this.isHealthy = opts.isHealthy ?? null;
    this.stamps = opts.stamps ?? new HealStampStore({ stampDir: this.stampDir, now: this.now });
    this.state = {
      phase: "PROBE",
      proposal: null,
      votes: [],
      lease: null,
      commitResult: null,
      verifyOk: null,
      idempotentSkip: null,
      stamp: null,
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
      force: !!input.force,
    };
    this.state.proposal = proposal;
    this.state.votes = [];
    this.log(
      `propose id=${proposal.proposalId} target=${proposal.target} action=${proposal.action} epoch=${proposal.epoch} force=${proposal.force}`,
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

  /**
   * Idempotency gate before mutate.
   * Returns skip info if heal should be a no-op success.
   */
  checkIdempotent() {
    const proposal = this.state.proposal;
    if (!proposal) return { skip: false, reason: "no-proposal" };
    const fp = healFingerprint(proposal);

    // 1. Cooldown stamp
    const cool = this.stamps.shouldSkip(proposal.target, proposal.action, {
      force: proposal.force,
      fingerprint: fp,
    });
    if (cool.skip) {
      this.log(
        `idempotent skip reason=${cool.reason} remainingMs=${cool.remainingMs ?? 0} fingerprint=${fp}`,
      );
      return { ...cool, fingerprint: fp };
    }

    // 2. Target already healthy (optional probe)
    if (!proposal.force && this.isHealthy) {
      try {
        if (this.isHealthy(proposal.target)) {
          this.log(`idempotent skip reason=already-healthy target=${proposal.target}`);
          return {
            skip: true,
            reason: "already-healthy",
            fingerprint: fp,
          };
        }
      } catch (e) {
        this.log(`isHealthy probe error: ${e.message || e}`);
      }
    }

    // 3. Target voter already online and evidence was for that node
    if (!proposal.force) {
      const targetVoter = this.voters.find((v) => v.id === proposal.target);
      if (targetVoter && targetVoter.health === "online") {
        // Only skip if evidence claimed this target was bad — recovered between propose and commit
        if (/offline|degraded|down|fail/i.test(proposal.evidence || "")) {
          this.log(`idempotent skip reason=target-recovered target=${proposal.target}`);
          return {
            skip: true,
            reason: "target-recovered",
            fingerprint: fp,
          };
        }
      }
    }

    return { skip: false, reason: "proceed", fingerprint: fp };
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

    // ── Idempotency gate ──
    const idem = this.checkIdempotent();
    this.state.idempotentSkip = idem;
    if (idem.skip) {
      const result = `skipped:${idem.reason}@${proposal.target}`;
      this.state.commitResult = result;
      this.log(`commit ${result}`);
      // Stamp as skipped_already_healthy / cooldown so retries stay quiet
      const stamp = this.stamps.write({
        target: proposal.target,
        action: proposal.action,
        fingerprint: idem.fingerprint,
        status: "skipped_already_healthy",
        holderId: proposal.proposerId,
        proposalId: proposal.proposalId,
        epoch: proposal.epoch,
        completedAt: this.now(),
        cooldownUntil: this.now() + cooldownFor(proposal.action, "ok"),
        result,
      });
      this.state.stamp = stamp;
      return result;
    }

    try {
      const result = await this.executor(proposal);
      this.state.commitResult = result;
      this.log(`commit ${result}`);
      return result;
    } catch (e) {
      const result = `failed:${e.message || e}@${proposal.target}`;
      this.state.commitResult = result;
      this.log(`commit ${result}`);
      const stamp = this.stamps.write({
        target: proposal.target,
        action: proposal.action,
        fingerprint: healFingerprint(proposal),
        status: "failed",
        holderId: proposal.proposerId,
        proposalId: proposal.proposalId,
        epoch: proposal.epoch,
        completedAt: this.now(),
        cooldownUntil: this.now() + cooldownFor(proposal.action, "failed"),
        result,
      });
      this.state.stamp = stamp;
      return result;
    }
  }

  verify(recoverFn) {
    this.setPhase("VERIFY");
    const proposal = this.state.proposal;
    const skipped = this.state.idempotentSkip?.skip === true;
    const failed =
      typeof this.state.commitResult === "string" &&
      this.state.commitResult.startsWith("failed:");

    if (recoverFn) recoverFn(this.voters);
    if (this.state.commitResult && !recoverFn && !skipped && !failed) {
      for (const v of this.voters) {
        if (v.health === "offline" || v.health === "degraded") {
          v.health = "online";
          v.epoch += 1;
        }
      }
    }
    const offline = this.voters.filter((v) => v.health === "offline").length;
    // Idempotent skip is a deliberate no-op success (prior stamp / already healthy).
    // Do not fail verify just because probe still shows offline evidence from this turn.
    this.state.verifyOk = failed ? false : skipped ? true : offline === 0;
    this.log(`verify offline=${offline} ok=${this.state.verifyOk} skipped=${!!skipped}`);

    // Post-verify success stamp (real execute path only)
    if (proposal && this.state.verifyOk && !skipped && !failed && !this.state.stamp) {
      const stamp = this.stamps.write({
        target: proposal.target,
        action: proposal.action,
        fingerprint: healFingerprint(proposal),
        status: "ok",
        holderId: proposal.proposerId,
        proposalId: proposal.proposalId,
        epoch: proposal.epoch,
        completedAt: this.now(),
        cooldownUntil: this.now() + cooldownFor(proposal.action, "ok"),
        result: this.state.commitResult,
      });
      this.state.stamp = stamp;
      this.log(
        `stamp written status=ok cooldownUntil=${stamp.cooldownUntil} fingerprint=${stamp.fingerprint}`,
      );
    }

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
      idempotentSkip: this.state.idempotentSkip?.skip
        ? {
            reason: this.state.idempotentSkip.reason,
            remainingMs: this.state.idempotentSkip.remainingMs ?? null,
          }
        : null,
      stamp: this.state.stamp
        ? {
            status: this.state.stamp.status,
            fingerprint: this.state.stamp.fingerprint,
            cooldownUntil: this.state.stamp.cooldownUntil,
          }
        : null,
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
    const base = join(process.cwd(), "artifacts", "heal-test-ok-" + Date.now());
    const engine = new ConsensusSelfHeal({
      leaseDir: join(base, "leases"),
      stampDir: join(base, "stamps"),
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
    assert(summary.stamp?.status === "ok", "stamp ok");
  });

  await t("split-brain: second proposer loses lease race", async () => {
    const dir = join(process.cwd(), "artifacts", "heal-leases-test-race-" + Date.now());
    const a = new ConsensusSelfHeal({ leaseDir: dir, stampDir: join(dir, "stamps-a") });
    const b = new ConsensusSelfHeal({ leaseDir: dir, stampDir: join(dir, "stamps-b") });
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
    const base = join(process.cwd(), "artifacts", "heal-test-noq-" + Date.now());
    const engine = new ConsensusSelfHeal({
      leaseDir: join(base, "leases"),
      stampDir: join(base, "stamps"),
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
    const base = join(process.cwd(), "artifacts", "heal-test-ttl-" + Date.now());
    const engine = new ConsensusSelfHeal({
      leaseDir: join(base, "leases"),
      stampDir: join(base, "stamps"),
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
    const base = join(process.cwd(), "artifacts", "heal-test-unk-" + Date.now());
    const engine = new ConsensusSelfHeal({
      leaseDir: join(base, "leases"),
      stampDir: join(base, "stamps"),
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

  // ── Idempotency tests ──

  await t("idempotent: cooldown skips second heal", async () => {
    let fakeNow = 2_000_000;
    const base = join(process.cwd(), "artifacts", "heal-test-cool-" + Date.now());
    const stamps = new HealStampStore({ stampDir: join(base, "stamps"), now: () => fakeNow });
    let execCount = 0;
    const engine = new ConsensusSelfHeal({
      leaseDir: join(base, "leases"),
      stampDir: join(base, "stamps"),
      stamps,
      now: () => fakeNow,
      executor: async (p) => {
        execCount += 1;
        return `executed:${p.action}@${p.target}`;
      },
    });
    engine.voters[1].health = "offline";
    const first = await engine.run({
      proposerId: "skill-orchestrator",
      target: "MediaCurator",
      action: "restart",
      evidence: "MediaCurator offline",
    });
    assert(first.commitResult?.startsWith("executed:"), "first executes");
    assert(execCount === 1, "exec once");
    assert(first.stamp?.status === "ok", "stamp ok");

    // Second run within cooldown — must skip
    engine.voters[1].health = "offline"; // evidence still claims offline
    const second = await engine.run({
      proposerId: "skill-orchestrator",
      target: "MediaCurator",
      action: "restart",
      evidence: "MediaCurator offline",
    });
    assert(second.commitResult?.startsWith("skipped:"), `second skipped, got ${second.commitResult}`);
    assert(execCount === 1, "executor not called again");
    assert(second.verifyOk === true, "skip still verifies ok");
    assert(second.idempotentSkip?.reason === "cooldown-active", "cooldown reason");
  });

  await t("idempotent: already-healthy skips mutate", async () => {
    const base = join(process.cwd(), "artifacts", "heal-test-healthy-" + Date.now());
    let execCount = 0;
    const engine = new ConsensusSelfHeal({
      leaseDir: join(base, "leases"),
      stampDir: join(base, "stamps"),
      isHealthy: () => true,
      executor: async (p) => {
        execCount += 1;
        return `executed:${p.action}@${p.target}`;
      },
    });
    // Target online; isHealthy true → skip even with offline-looking evidence path
    const summary = await engine.run({
      proposerId: "skill-orchestrator",
      target: "MediaCurator",
      action: "restart",
      evidence: "MediaCurator offline",
    });
    assert(summary.commitResult?.startsWith("skipped:"), `got ${summary.commitResult}`);
    assert(execCount === 0, "executor never called");
    assert(summary.stamp?.status === "skipped_already_healthy", "stamp status");
  });

  await t("idempotent: force bypasses cooldown", async () => {
    let fakeNow = 3_000_000;
    const base = join(process.cwd(), "artifacts", "heal-test-force-" + Date.now());
    const stamps = new HealStampStore({ stampDir: join(base, "stamps"), now: () => fakeNow });
    let execCount = 0;
    const mk = () =>
      new ConsensusSelfHeal({
        leaseDir: join(base, "leases"),
        stampDir: join(base, "stamps"),
        stamps,
        now: () => fakeNow,
        executor: async (p) => {
          execCount += 1;
          return `executed:${p.action}@${p.target}`;
        },
      });

    const e1 = mk();
    e1.voters[1].health = "offline";
    await e1.run({
      proposerId: "skill-orchestrator",
      target: "MediaCurator",
      action: "restart",
      evidence: "MediaCurator offline",
    });
    assert(execCount === 1, "first exec");

    const e2 = mk();
    e2.voters[1].health = "offline";
    const forced = await e2.run({
      proposerId: "skill-orchestrator",
      target: "MediaCurator",
      action: "restart",
      evidence: "MediaCurator offline",
      force: true,
    });
    assert(forced.commitResult?.startsWith("executed:"), `force executes, got ${forced.commitResult}`);
    assert(execCount === 2, "executor called again under force");
  });

  await t("idempotent: fingerprint change allows re-heal", async () => {
    let fakeNow = 4_000_000;
    const base = join(process.cwd(), "artifacts", "heal-test-fp-" + Date.now());
    const stamps = new HealStampStore({ stampDir: join(base, "stamps"), now: () => fakeNow });
    let execCount = 0;
    const mk = () =>
      new ConsensusSelfHeal({
        leaseDir: join(base, "leases"),
        stampDir: join(base, "stamps"),
        stamps,
        now: () => fakeNow,
        executor: async (p) => {
          execCount += 1;
          return `executed:${p.action}@${p.target}`;
        },
      });

    const e1 = mk();
    e1.voters[1].health = "offline";
    await e1.run({
      proposerId: "skill-orchestrator",
      target: "MediaCurator",
      action: "restart",
      evidence: "MediaCurator offline latency=-1",
    });
    assert(execCount === 1, "first");

    // Different evidence → different fingerprint → not skipped by cooldown match rule
    const e2 = mk();
    e2.voters[1].health = "offline";
    const second = await e2.run({
      proposerId: "skill-orchestrator",
      target: "MediaCurator",
      action: "restart",
      evidence: "MediaCurator offline latency=-1 code=ECONNRESET",
    });
    assert(second.commitResult?.startsWith("executed:"), `re-heal on fp change, got ${second.commitResult}`);
    assert(execCount === 2, "second exec");
  });

  await t("idempotent: failed stamp does not block forever", async () => {
    let fakeNow = 5_000_000;
    const base = join(process.cwd(), "artifacts", "heal-test-fail-" + Date.now());
    const stamps = new HealStampStore({ stampDir: join(base, "stamps"), now: () => fakeNow });
    let attempt = 0;
    const engine = new ConsensusSelfHeal({
      leaseDir: join(base, "leases"),
      stampDir: join(base, "stamps"),
      stamps,
      now: () => fakeNow,
      executor: async (p) => {
        attempt += 1;
        if (attempt === 1) throw new Error("boom");
        return `executed:${p.action}@${p.target}`;
      },
    });
    engine.voters[1].health = "offline";
    const first = await engine.run({
      proposerId: "skill-orchestrator",
      target: "MediaCurator",
      action: "restart",
      evidence: "MediaCurator offline",
    });
    assert(first.commitResult?.startsWith("failed:"), `got ${first.commitResult}`);
    assert(first.verifyOk === false, "verify fails");
    assert(first.stamp?.status === "failed", "failed stamp");

    // After failed cooldown, retry succeeds
    fakeNow += COOLDOWN_FAILED_MS + 1;
    engine.voters[1].health = "offline";
    const second = await engine.run({
      proposerId: "skill-orchestrator",
      target: "MediaCurator",
      action: "restart",
      evidence: "MediaCurator offline",
    });
    assert(second.commitResult?.startsWith("executed:"), `retry after fail cooldown, got ${second.commitResult}`);
    assert(second.verifyOk === true, "verify ok");
  });

  await t("actionKey + fingerprint stable", () => {
    assert(actionKey("A", "restart") === actionKey("A", "restart"), "key stable");
    assert(actionKey("A", "restart") !== actionKey("A", "reconnect"), "key differs by action");
    const p1 = { target: "X", action: "restart", evidence: "offline" };
    const p2 = { target: "X", action: "restart", evidence: "offline" };
    const p3 = { target: "X", action: "restart", evidence: "offline other" };
    assert(healFingerprint(p1) === healFingerprint(p2), "fp stable");
    assert(healFingerprint(p1) !== healFingerprint(p3), "fp differs");
  });

  await t("cooldownFor destructive vs soft", () => {
    assert(cooldownFor("restart") === COOLDOWN_DESTRUCTIVE_MS, "restart destructive");
    assert(cooldownFor("reconnect") === COOLDOWN_SOFT_MS, "reconnect soft");
    assert(cooldownFor("restart", "failed") === COOLDOWN_FAILED_MS, "failed short");
  });

  return results;
}

async function main() {
  const args = process.argv.slice(2);
  const jsonOnly = args.includes("--json");
  const demoOnly = args.includes("--demo");
  const gateOnly = args.includes("--gate");

  // Lightweight gate for pke-self-heal startup: no unit suite, no demo mutate.
  // Reports stamp-store readiness + cooldown policy only.
  if (gateOnly) {
    const store = new HealStampStore({
      stampDir: join(process.cwd(), "artifacts", "heal-stamps"),
    });
    const payload = {
      ok: true,
      mode: "gate",
      stampDir: store.stampDir,
      cooldown: {
        softMs: COOLDOWN_SOFT_MS,
        destructiveMs: COOLDOWN_DESTRUCTIVE_MS,
        failedMs: COOLDOWN_FAILED_MS,
      },
      majority: majority(5),
      phases: ["PROBE", "PROPOSE", "VOTE", "LEASE", "COMMIT", "VERIFY", "RELEASE"],
      idempotency: [
        "pre-commit cooldown stamp",
        "pre-commit already-healthy probe",
        "post-verify success stamp",
        "failed short cooldown",
        "force bypass",
      ],
    };
    console.log(JSON.stringify(payload, null, jsonOnly ? 0 : 2));
    return;
  }

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
    stampDir: join(process.cwd(), "artifacts", "heal-stamps"),
  });
  engine.voters[1].health = "offline";
  engine.voters[3].health = "degraded";
  const summary = await engine.run({
    proposerId: "skill-orchestrator",
    target: "MediaCurator",
    action: "restart+edge-resync",
    evidence: "MediaCurator offline · edge-sync degraded",
  });

  // Second demo run — should idempotent-skip
  engine.voters[1].health = "offline";
  const summary2 = await engine.run({
    proposerId: "skill-orchestrator",
    target: "MediaCurator",
    action: "restart+edge-resync",
    evidence: "MediaCurator offline · edge-sync degraded",
  });

  if (jsonOnly) {
    console.log(
      JSON.stringify({ ok: true, tests: testResults, demo: summary, demoIdempotent: summary2 }, null, 2),
    );
  } else {
    console.log("\n=== Demo: heal MediaCurator via consensus ===");
    console.log(`phase=${summary.phase} quorum=${summary.quorum} verify=${summary.verifyOk}`);
    console.log(`commit=${summary.commitResult}`);
    console.log(`stamp=${JSON.stringify(summary.stamp)}`);
    console.log("votes:", summary.votes.map((v) => `${v.id}:${v.decision}`).join(" "));
    console.log("\n=== Demo: immediate retry (idempotent) ===");
    console.log(`commit=${summary2.commitResult}`);
    console.log(`idempotentSkip=${JSON.stringify(summary2.idempotentSkip)}`);
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
