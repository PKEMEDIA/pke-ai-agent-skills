# Heal Idempotency Safeguards

**Stamp:** 2026-08-01  
**Scope:** skill-orchestrator consensus engine + pke-self-heal  
**Status:** LIVE · unit suite 13/13 · bash run-gate enforced

## Problem

Lease exclusivity alone is not enough:

1. Lease holder can crash mid-COMMIT  
2. Lease TTL expires → second healer acquires lease  
3. Without idempotency → double restart, thrashing, duplicate GitHub pushes, partial rewrites  

Consensus answers “who may act.” Idempotency answers “is acting still necessary?”

## Design

```
PROBE → PROPOSE → VOTE → LEASE → [IDEM CHECK] → COMMIT → VERIFY → STAMP → RELEASE
```

### Stamp registry

Directory: `artifacts/heal-stamps/`

| File | Purpose |
| --- | --- |
| `stamp-<sha1(target|action)[:12]>.json` | Per-action result + cooldown |
| `run-cooldown.json` | Global pass counter for pke-self-heal |
| `last-consensus.json` | Last `--gate` engine readiness report |

### Status values

| Status | Meaning | Cooldown |
| --- | --- | --- |
| `ok` | Mutate succeeded + verify passed | destructive 120s / soft 60s |
| `skipped_already_healthy` | No-op; already healthy or cooldown hit | same as ok |
| `failed` | Executor threw or verify failed | 30s only |

### Pre-commit skip rules (in order)

1. **`force: true`** → never skip (operator override)  
2. **Cooldown active** + prior `ok` / `skipped_already_healthy` + matching fingerprint → skip  
3. **`isHealthy(target)`** probe returns true → skip  
4. **Target voter already online** while evidence claimed offline/degraded → skip  
5. Else → execute  

### Fingerprint

`sha1(target|action|evidence)[:16]`

### pke-self-heal.sh integration

- Consensus `--gate` at START
- Global run gate: max 2 passes per 120s unless `--force`
- Per-action helpers: `heal_should_skip`, `heal_stamp_write`

### Unit tests (idempotency)

cooldown skips second heal · already-healthy · force bypass · fingerprint change · failed short cooldown · actionKey stable · cooldownFor TTLs

See live engine: `scripts/consensus-self-heal.mjs` (13/13 PASS).
