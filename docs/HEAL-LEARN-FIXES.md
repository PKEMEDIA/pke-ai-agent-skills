# Heal · Learn · CI Fixes

**Stamp:** 2026-08-01 · consensus + idempotency synced to GitHub · CI gate live

## Synced (local → GitHub)

| Path | Notes |
| --- | --- |
| `skill-orchestrator/scripts/consensus-self-heal.mjs` | Full Raft-lite + HealStampStore · 13/13 · `--gate` |
| `skill-orchestrator/scripts/pke-self-heal.sh` | Gate at START · run-gate max 2/120s · stamp helpers |
| `scripts/consensus-self-heal.mjs` | Mirror for Mac paste / docs |
| `scripts/pke-self-heal.sh` | Mirror for Mac paste / docs |
| `skill-orchestrator/references/heal-idempotency.md` | Protocol + skip rules |
| `skill-orchestrator/references/distributed-consensus-self-heal.md` | Raft-lite design |
| `.github/workflows/pke-skill-ci.yml` | Consensus step before parallel validate |

## CI contract

1. `node …/consensus-self-heal.mjs --gate` must print `ok: true`
2. Full suite must exit 0 (13/13)
3. Parallel skill validate FAIL=0
4. Brand + permanent-activation + engine files present

## Local Mac

```bash
export PKE_ROOT="$HOME"
cd "$HOME/pke-ai-agent-skills"
node scripts/consensus-self-heal.mjs --gate
bash scripts/pke-self-heal.sh
```

## Status

**SYNCED · CI GATE LIVE · IDEMPOTENT · NO THRASH · SPEED PRESERVED**
