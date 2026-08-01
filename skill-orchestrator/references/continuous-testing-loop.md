# Continuous Testing Loop

**Executable**: `scripts/continuous-testing-loop.sh`

## Quick Start
```bash
# Basic loop (3 iterations max)
./scripts/continuous-testing-loop.sh

# With bisect guidance on failure
./scripts/continuous-testing-loop.sh 5 --bisect-on-fail
```

## What the loop does each iteration
1. Structural validation of every custom skill via `validate-skill.sh`
2. Collects failed skill names
3. On clean run → automatic snapshot via `skill-vcs.sh auto`
4. Quick size scan (flags SKILL.md > 300 lines)
5. If `--bisect-on-fail` and failures exist → prints ready-to-run bisect command for the first failure
6. Early-exits on full success

## Integration with Bisect
When a skill fails, the recommended next step is:

```bash
# Find a recent good commit
git log --oneline -10

# Then run automated bisect with the appropriate preset
./scripts/bisect-skill.sh <good-commit> <skill-name>
./scripts/bisect-skill.sh <good-commit> <skill-name> --preset frontmatter
./scripts/bisect-skill.sh <good-commit> <skill-name> --preset trigger
```

## Available Bisect Presets / Test Templates
Located in `scripts/bisect-tests/`:

| Preset / Script              | What it checks                          |
|------------------------------|-----------------------------------------|
| structural (default)         | Full `validate-skill.sh`                |
| frontmatter                  | YAML frontmatter presence & keys        |
| trigger                      | Basic description length / quality      |
| demo                         | Built-in demo status test               |

Add new templates by dropping executable scripts into `bisect-tests/` that exit 0 on success and non-zero on failure.

## Exit Conditions
- All skills pass → success + auto-snapshot
- Max iterations reached → report remaining failures + bisect guidance

This loop is the operational heart of continuous skill ecosystem health under the Orchestrator.
