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
| `stamp-<sha1(target\|action)[:12]>.json` | Per-action result + cooldown |
| `run-cooldown.json` | Global pass counter for pke-self-heal |
| `last-consensus.json` | Last `--gate` engine readiness report |

Stamp shape:

```json
{
  "target": "MediaCurator",
  "action": "restart",
  "fingerprint": "a3e680cde922f3b4",
  "status": "ok",
  "holderId": "skill-orchestrator",
  "proposalId": "uuid",
  "epoch": 1,
  "completedAt": 1785575000000,
  "cooldownUntil": 1785575120000,
  "result": "executed:restart@MediaCurator"
}
```

### Status values

| Status | Meaning | Cooldown |
| --- | --- | --- |
| `ok` | Mutate succeeded + verify passed | destructive 120s / soft 60s |
| `skipped_already_healthy` | No-op; already healthy or cooldown hit | same as ok |
| `failed` | Executor threw or verify failed | 30s only |

Destructive action heuristic: `/restart|archive|bulk|rewrite|push|delete|wipe|force/i`

### Pre-commit skip rules (in order)

1. **`force: true`** → never skip (operator override)  
2. **Cooldown active** + prior `ok` / `skipped_already_healthy` + matching fingerprint → skip  
3. **`isHealthy(target)`** probe returns true → skip  
4. **Target voter already online** while evidence claimed offline/degraded → skip (recovered between propose and commit)  
5. Else → execute  

### Fingerprint

`sha1(target|action|evidence)[:16]`

Same target+action with **different evidence** (new failure mode) is allowed to re-heal inside cooldown. Same fingerprint is suppressed.

### pke-self-heal.sh integration

- Consensus **`--gate`** at **START** (not dead code after `exit`)  
- Global **run gate**: max **2 passes** per **120s** window unless `--force` / `PKE_HEAL_FORCE=1`  
- Per-action helpers: `heal_should_skip`, `heal_stamp_write`  
- `heal_app` and `heal_github` stamp success / already-synced / failure  
- `restore_asset` already was “exists → no-op” (content presence gate)  

```bash
bash scripts/pke-self-heal.sh           # normal
bash scripts/pke-self-heal.sh --push    # include GitHub push
bash scripts/pke-self-heal.sh --force   # bypass run + action cooldowns
```

### Engine CLI

```bash
node consensus-self-heal.mjs            # full unit suite + demo
node consensus-self-heal.mjs --gate     # lightweight readiness for heal startup
node consensus-self-heal.mjs --json     # machine-readable
node consensus-self-heal.mjs --demo     # demo only
```

### Unit tests (idempotency)

| Test | Expectation |
| --- | --- |
| cooldown skips second heal | executor called once; second `skipped:cooldown-active` |
| already-healthy skips mutate | executor never called |
| force bypasses cooldown | second call executes |
| fingerprint change allows re-heal | different evidence → execute |
| failed stamp does not block forever | after 30s failed cooldown → retry executes |
| actionKey + fingerprint stable | deterministic hashing |
| cooldownFor destructive vs soft | 120s / 60s / 30s |

## Safety notes

- Idempotency does **not** replace quorum or lease — it layers on top  
- Skipped commits still VERIFY as success (deliberate no-op)  
- Failed stamps never claim `ok`  
- Never invent binary assets in skill heal (unchanged rule)  
- Platform wall unchanged: no foundation weight / quota mutation  

## Edge cases

| Case | Behavior |
| --- | --- |
| Lease expires mid-commit, retry arrives | Stamp absent or failed → may re-run; if prior commit finished and stamped → skip |
| Clock skew | Prefer short TTLs; stamps use wall clock same as leases |
| Partial file write | frontmatter fix only writes when content changes; assets only when missing |
| GitHub already synced | `git diff --cached --quiet` → `skipped_already_healthy` stamp |
| Operator needs immediate re-heal | `--force` / `force: true` |

## See also

- `distributed-consensus-self-heal.md` — lease protocol  
- `distributed-consensus-algorithms.md` — algorithm choice  
- `self-healing-protocol.md` — skill-body auto-remediation rules  
- `scripts/consensus-self-heal.mjs` — engine + tests  
- `scripts/pke-self-heal.sh` — bash orchestration  
- `scripts/heal-lease.sh` — multi-process exclusive lease  
