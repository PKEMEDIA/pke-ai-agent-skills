# Distributed Consensus Algorithms — Investigation

**Stamp:** 2026-08-01  
**Scope:** Theory + mapping to PKE Raft-lite heal consensus  
**Status:** LIVE investigation · engine 6/6 green

## Problem consensus solves

Multiple independent processes (or agents) must agree on **one value / one action** despite:
- crash failures
- network partitions
- concurrent proposers
- stale messages

Without agreement: split-brain (two heals restart the same service, thrash ports, corrupt state).

## Classic algorithms (comparison)

| Algorithm | Model | Strength | Cost / complexity | Best for |
| --- | --- | --- | --- | --- |
| **Paxos** (Lamport) | Asynchronous + crash | Proven, minimal assumptions | Hard to implement correctly; many roles (proposer/acceptor/learner) | Theory, embedded systems needing formal minimalism |
| **Multi-Paxos** | Paxos + stable leader | Efficient log replication after leader elected | Still subtle edge cases | Replicated state machines (early systems) |
| **Raft** (Ongaro/Ousterhout) | Leader-based RSM | Understandable; strong tooling (etcd, Consul) | Leader bottleneck; election storms under flaky nets | Production KV, service discovery, config |
| **Zab** (ZooKeeper) | Primary-backup | Proven in ZK | Coupled to ZK stack | Coordination services |
| **Viewstamped Replication** | View changes + primary | Close cousin of Raft lineage | Less mindshare than Raft | Historical / research |
| **PBFT** (Castro/Liskov) | Byzantine faults | Survives malicious nodes | 3f+1 nodes; high message cost | Hostile multi-tenant / blockchain-adjacent |
| **HotStuff / Tendermint** | BFT + pipelining | Modern chain-friendly | Complex; often overkill | Permissioned chains, validators |
| **Raft-lite / lease consensus** (PKE) | Majority vote + exclusive lease | Small surface; heal-scoped | Not a full log RSM | Self-heal, exclusive ops, multi-agent exclusivity |

## Properties that matter

### Safety
- **Agreement:** no two correct nodes decide different values for the same slot/target
- **Validity:** decided value was proposed
- **Integrity:** decide once (or per epoch with clear supersession)

### Liveness
- Progress if majority available and network eventually delivers
- Raft/Paxos cannot guarantee both safety and liveness under full asynchrony + partitions (FLP related tradeoffs); practical systems add timeouts/elections

### Fault model
| Model | Failures tolerated | Node formula (classic) |
| --- | --- | --- |
| Crash-stop | f crashes | 2f+1 (majority) |
| Crash + network partition | f in minority | majority quorum |
| Byzantine | f malicious | 3f+1 (PBFT family) |

PKE heal swarm is **crash / offline**, not Byzantine → majority (2f+1) is correct.

## Raft (what "Raft-lite" borrows)

Full Raft has three sub-problems:
1. **Leader election** (terms, randomized timeouts)
2. **Log replication** (AppendEntries, commit index)
3. **Safety** (only leaders with up-to-date logs elected; commit rules)

PKE **does not** implement a replicated log. It borrows:
- **term/epoch** idea (epoch on proposals / recovered nodes)
- **majority quorum**
- **single leader-like lease holder** for a target
- **timeout** (proposal TTL 30s, lease TTL 60s)

It intentionally skips:
- continuous log replication
- joint consensus membership change
- snapshotting
- leader heartbeat stream

That is correct for **one-shot exclusive heal actions**, not for a distributed database.

## Paxos (why not full Paxos here)

Paxos phases:
1. Prepare/Promise (ballot numbers)
2. Accept/Accepted
3. Learn

Multi-Paxos stabilizes a leader to avoid per-slot Prepare storms.

For skill heal:
- You need **one action per target** with exclusivity
- You do **not** need an infinite command log
- File lease + majority ACK is enough and auditable

Using full Paxos would add complexity without product value under the platform wall (no multi-datacenter RSM requirement for skill text heals).

## Byzantine (why not PBFT here)

PBFT tolerates lying agents. Your voters are:
- skill-orchestrator
- MediaCurator / Compilation-Builder (process health)
- edge-sync
- skill-test-suite

Threat model is **crash / stale / offline**, not adversarial falsification of votes inside your own Mac Pro + Grok sandbox. PBFT would require 3f+1 and much more messaging. Overkill.

If later open multi-tenant healers vote remotely without trust, revisit BFT or signed votes.

## Lease-based consensus (what you run)

```
PROBE → PROPOSE → VOTE → LEASE → COMMIT → VERIFY → RELEASE
```

| Phase | Purpose | Failure mode handled |
| --- | --- | --- |
| PROBE | Observe voter health | Offline NACKs |
| PROPOSE | Single proposal identity | Unknown / offline proposer abort |
| VOTE | Majority ACK | No-quorum abort |
| LEASE | Exclusive holder per target | Split-brain race reject |
| COMMIT | Exactly-once action by holder | Lease expiry abort |
| VERIFY | Re-probe after action | Cooldown + new epoch if fail |
| RELEASE | Clear lease | Crash → TTL expiry |

### Quorum math
```
majority(N) = floor(N/2) + 1
N=5 → 3 ACK
```

### Dual implementation
| Path | Mechanism | Audience |
| --- | --- | --- |
| `consensus-self-heal.mjs` | Full phase machine + unit tests | Grok/Build, CI, orchestrator |
| `heal-lease.sh` | File lease + optional edge KV mirror | launchd workers on Mac Pro |

## Mapping algorithms → PKE choices

| Need | Choose |
| --- | --- |
| Exclusive self-heal of one service | **Raft-lite lease (current)** |
| Shared config / service discovery cluster | Full **Raft** (etcd/Consul) |
| Adversarial multi-party | **PBFT / HotStuff** family |
| Formal minimal protocol research | **Paxos** |
| Creative multi-agent brainstorm | **Not consensus** — use L2 KittyMindTeam multi-option (disagreement is fine) |

**Critical design insight:** Multi-agent *creative* swarm wants diversity of options. Multi-agent *heal* swarm wants **one** action. Different algorithms for different layers (see swarm L0 vs L2).

## Edge cases & implications

1. **Partition:** majority side can heal; minority side blocks (safety preserved, liveness on minority sacrificed) — correct.
2. **Lease crash mid-commit:** TTL frees target; may double-heal after TTL — mitigate with idempotent heals + cooldown.
3. **Clock skew:** file lease uses wall clock; prefer short TTL + monotonic where available; edge KV should use server time.
4. **False offline NACK:** reduces ACK count; may block heal — better than split-brain.
5. **Name-mention dependency cycles:** not consensus cycles; do not feed them into quorum membership.
6. **GitHub as L4 truth:** eventual consistency for skill text, not linearizable heal lease — do not conflate.

## Recommendations

1. **Keep Raft-lite for heals** — validated 6/6; right abstraction.
2. **Idempotent heal bodies** — so lease-expiry double commit is safe.
3. **Optional:** signed votes if remote untrusted agents join quorum.
4. **Optional:** edge KV lease as primary when multi-device (iOS + Mac + Build) heals race.
5. **Do not** replace creative multi-option generation with majority vote — that collapses artistic exploration.
6. **Document membership:** only processes that can *observe* target health should vote.

## Test gates (live)

```bash
node skill-orchestrator/scripts/consensus-self-heal.mjs
# majority math · happy path · split-brain · no-quorum · stale TTL · unknown proposer
```

## See also
- `distributed-consensus-self-heal.md` — operational protocol
- `agent-meeting-protocol.md` — L1 multi-skill synthesis (not consensus)
- `autonomous-ecosystem` — when disagreement is allowed vs when agreement is mandatory
