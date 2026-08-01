# Distributed Consensus for Self-Healing

**Scope:** COVICEA Sentient Empire Office + PKE skill-orchestrator  
**Date:** 2026-07-30  
**Status:** LIVE · engine tested · lease helper ready for Mac Pro multi-process

## Problem

Multiple healers can race the same target without coordination → double restarts, thrashing, split-brain lease on tunnels/ports.

## Design (Raft-lite, heal-scoped)

```
PROBE → PROPOSE → VOTE → LEASE → COMMIT → VERIFY → RELEASE
```

Quorum: majority(N) = floor(N/2) + 1 · Default N = 5 → 3 ACK

Lease: exclusive per target · TTL 60s · file-backed

## Idempotency (2026-08-01)

Lease exclusivity answers **who** may heal. Idempotency answers **whether** a heal is still needed after lease expiry or retry.

See **`heal-idempotency.md`** for:

- Stamp registry (`artifacts/heal-stamps/`)
- Pre-commit skip rules (cooldown, already-healthy, fingerprint)
- Cooldown TTLs (destructive 120s / soft 60s / failed 30s)
- `force` bypass
- pke-self-heal run gate (max 2 passes / 120s)

Engine unit suite includes 7 idempotency tests (13/13 total PASS).

## Artifacts

| File | Purpose |
| --- | --- |
| `scripts/consensus-self-heal.mjs` | Engine + unit tests + demo + idempotency |
| `scripts/heal-lease.sh` | Bash exclusive lease for launchd workers |
| `scripts/pke-self-heal.sh` | Bash orchestration with run-gate + stamps |
| `references/heal-idempotency.md` | Full idempotency protocol |
