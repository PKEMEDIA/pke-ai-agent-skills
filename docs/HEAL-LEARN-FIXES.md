# Self-heal / Learn repair log — 2026-07-30

## Bugs fixed

| # | Severity | Bug | Fix |
|---|---|---|---|
| 1 | High | heal_github unconditional cp aborts under set -e | Guarded copies; copied counter |
| 2 | Medium | startup.sh restore never re-probed app | Re-curl; FAILS if still down |
| 3 | Medium | github-clone-FAILED skipped FAILS_AFTER | Now increments |
| 4 | Medium | ROOT hardcoded /workspace | Auto-detect workspace/home/cwd |
| 5 | Medium | VALIDATE path hardcoded | Search 4 candidate paths |
| 6 | Low | Empty ACTIONS printed blank dash | Print (none) |
| 7 | Low | Skill dirs without SKILL.md counted | Skip |
| 8 | Low | learn [ ] && PUSH under set -e | if/fi |
| 9 | Medium | Learn Python hardcode validate | argv[5] + fallbacks |
| 10 | Low | Post-learn validate crash if missing | Guard |

## Verification

- bash -n syntax OK
- Brand skills validate OK
- Remote scripts/ restored with full hardened bodies
