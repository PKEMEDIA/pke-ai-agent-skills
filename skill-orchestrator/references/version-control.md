# Skill Version Control System

**Activated**: 2026-07-25 under Beast Mode Skill Orchestrator  
**Automation**: Snapshot triggers + full bisect automation

## Core Commands (`scripts/skill-vcs.sh`)

```bash
./scripts/skill-vcs.sh status
./scripts/skill-vcs.sh snapshot "message"
./scripts/skill-vcs.sh auto ["reason"]          # smart auto-commit if dirty
./scripts/skill-vcs.sh log
./scripts/skill-vcs.sh diff

# Bisect suite
./scripts/skill-vcs.sh bisect start [bad] <good>
./scripts/skill-vcs.sh bisect good
./scripts/skill-vcs.sh bisect bad
./scripts/skill-vcs.sh bisect run "test-command"
./scripts/skill-vcs.sh bisect reset
./scripts/skill-vcs.sh bisect log
./scripts/skill-vcs.sh bisect status
```

## High-level Skill Bisect (`scripts/bisect-skill.sh`)

One-command automated debugging:

```bash
# Demo mode (uses the built-in test)
./scripts/bisect-skill.sh <known-good-commit> --demo

# Real skill (runs validate-skill.sh automatically)
./scripts/bisect-skill.sh <known-good-commit> covicea-core
./scripts/bisect-skill.sh <known-good-commit> skill-orchestrator
```

The script:
1. Starts bisect (bad = HEAD, good = the commit you supply)
2. Runs the test at every midpoint
3. Automatically marks good/bad
4. Reports the first bad commit
5. Resets the working tree

## Automated Snapshot Triggers

| Event                        | Condition          | Reason tag            |
|------------------------------|--------------------|-----------------------|
| Successful bulk validation   | 0 failures         | post-bulk-validate    |
| Explicit call                | Working tree dirty | custom / orchestrator |

## Example Test Script
`scripts/test-demo-status.sh` — simple template that exits 0 on good, 1 on bad.  
Copy and adapt for any custom regression test.

## Recovery & History
```bash
git checkout -- path/to/file
git log -- path/to/skill/
git show <commit>:path/to/file
```

`.gitignore` excludes media, caches, and `*.bak.*` files.

This system turns the skill ecosystem into a fully debuggable, versioned, and self-documenting codebase.

## Continuous Testing Loop Integration
The loop script (`continuous-testing-loop.sh`) automatically:
- Runs validation
- Snapshots on success
- Surfaces ready-to-run bisect commands on failure

See `references/continuous-testing-loop.md` for full details.
