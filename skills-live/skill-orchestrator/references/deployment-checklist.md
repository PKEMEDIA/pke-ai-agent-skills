# Deployment Checklist — skill-orchestrator

**Purpose**: Gate every ecosystem ship to chat · iOS · web. Run before calling Finalize complete or after skill-creator publishes.

Last updated: 2026-10-01

---

## Pre-flight (always)

- [ ] Working tree under `$PKE_ROOT` or `~/.grok/skills/` is the source of truth (not `/tmp`)
- [ ] No unvalidated edits pending re-check
- [ ] Platform wall understood: no claim of foundation-weight or SuperGrok-quota change

## Structural & tests

- [ ] `bash "$PKE_ROOT/skill-creator/scripts/validate-skill.sh"` (fallback `~/.grok/skills/skill-creator/scripts/validate-skill.sh`) OK on every touched skill
- [ ] Full sweep: structural N/N OK (bundled + custom)
- [ ] `node scripts/wasm-validate-harness.mjs` → Pass = Skills count, Fail = 0
- [ ] `node scripts/spicy-error-unit-tests.mjs` → 15/15 PASS
- [ ] No skill body over ~350 lines without auto-split
- [ ] Circular deps: none (`scripts/generate-dependency-graph.py`)

## Meta triangle

- [ ] skill-orchestrator valid
- [ ] skill-creator valid
- [ ] paralegal-assistant valid; locked legal operative text not rewritten by health loops

## Ops habit

```bash
bash "$PKE_ROOT/skill-orchestrator/scripts/orchestrate-finalize.sh"
bash "$PKE_ROOT/skill-orchestrator/scripts/bulk-validate.sh"
node "$PKE_ROOT/skill-orchestrator/scripts/wasm-validate-harness.mjs"
```

After skill-creator add or capability change, run orchestrate-finalize before calling ship done.
