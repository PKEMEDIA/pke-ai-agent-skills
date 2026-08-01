# Distributed Consensus for Self-Healing

**Scope:** COVICEA Sentient Empire Office + PKE skill-orchestrator  
**Date:** 2026-07-30  
**Status:** LIVE · engine tested · lease helper ready for Mac Pro multi-process

## Problem

Multiple healers can race the same target:

| Healer | Path |
| --- | --- |
| `orchestrator-self-heal.sh` | launchd `com.covicea.orchestrator-self-heal` |
| `autonomous-worker.sh` | deep heal POST + cooldown stamp |
| `grok-watch.sh` | continuous patrol |
| `repair-agents.sh` | agent repair |
| `pke-self-heal.sh` | skill ecosystem (Grok / Build) |
| Grok multi-agent turns | concurrent orchestrator runs |

Without coordination → double restarts, thrashing, split-brain lease on tunnels/ports.

## Design (Raft-lite, heal-scoped)

Not full multi-Paxos. Heal actions need **agreement + exclusivity**, not continuous log replication.

```
PROBE → PROPOSE → VOTE → LEASE → COMMIT → VERIFY → RELEASE
```

### Roles

| Role | Default nodes |
| --- | --- |
| Coordinator | `skill-orchestrator` |
| Specialists | `MediaCurator`, `Compilation-Builder` |
| Edge | `edge-sync` / covicea-edge |
| Validator | `skill-test-suite` |

On Mac Pro, map to process identities: `autonomous-worker`, `orchestrator-self-heal`, `grok-watch`, `port-guard`, `edge-sync`.

### Quorum

majority(N) = floor(N/2) + 1

Default N = 5 → need **3 ACK** votes.

### Proposal

```json
{
  "proposalId": "uuid",
  "proposerId": "skill-orchestrator",
  "target": "MediaCurator",
  "action": "restart",
  "evidence": "offline latency=-1",
  "epoch": 12,
  "ts": 1710000000000
}
```

### Vote rules

- Offline voters → NACK (cannot observe)
- Proposer + coordinator → ACK if proposal valid
- Others ACK when evidence matches observed failure (`offline|degraded|down|fail`)
- Quorum required before lease

### Lease

- Exclusive per **target** (not global)
- TTL default **60s**
- File-backed: `~/Library/Logs/covicea-heal-leases/lease-<hash>.json`
- Engine: `artifacts/heal-leases/` (skill / CI)
- Stale holder rejected; only holder may release

### Commit + verify

1. Only lease holder executes action once
2. Re-probe voters / health endpoints
3. Bump epoch on recovered nodes
4. Release lease
5. If verify fails → new epoch after cooldown (no tight loop)

## Artifacts

| File | Purpose |
| --- | --- |
| `scripts/consensus-self-heal.mjs` | Engine + unit tests + demo |
| `scripts/heal-lease.sh` | Bash exclusive lease for launchd workers |
| `references/distributed-consensus-self-heal.md` | This protocol |

## Integration

### skill-orchestrator / pke-self-heal

Before destructive auto-actions (archive, bulk rewrite, GitHub push):

```bash
node skill-orchestrator/scripts/consensus-self-heal.mjs --json
```

### Mac Pro workers

```bash
source deploy/heal-lease.sh
TARGET="compile-studio"
HOLDER="autonomous-worker"
if heal_lease_acquire "$TARGET" "$HOLDER" 90; then
  # existing heal body...
  heal_lease_release "$TARGET" "$HOLDER"
fi
```

Wrap `orchestrator-self-heal.sh` and the deep-heal block in `autonomous-worker.sh` the same way.

### Edge KV (optional next)

Mirror lease keys into covicea-edge KV (`heal:lease:<target>`) so iOS / remote agents respect the same exclusivity.

## Safety

- Never invent binary assets in skill heal
- Platform wall: cannot change foundation weights/quotas
- Max 2 auto-heal passes per turn (existing pke-self-heal rule)
- Lease TTL prevents permanent lock after crash

## Test gates

```bash
node scripts/consensus-self-heal.mjs
# PASS majority math
# PASS happy path
# PASS split-brain race rejection
# PASS no-quorum abort
# PASS stale proposal TTL
# PASS unknown proposer reject
```

## Stamp

- **2026-07-30 00:37 EDT** — Distributed consensus self-heal implemented  
- Engine unit suite green · lease helper ready · protocol wired into skill-orchestrator references

## Idempotency (2026-08-01)

Lease exclusivity answers **who** may heal. Idempotency answers **whether** a heal is still needed after lease expiry or retry.

See **`heal-idempotency.md`** for:

- Stamp registry (`artifacts/heal-stamps/`)
- Pre-commit skip rules (cooldown, already-healthy, fingerprint)
- Cooldown TTLs (destructive 120s / soft 60s / failed 30s)
- `force` bypass
- pke-self-heal run gate (max 2 passes / 120s)

Engine unit suite includes 7 idempotency tests (13/13 total PASS).
