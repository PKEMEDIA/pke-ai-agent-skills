#!/bin/bash
# Bulk Skill Validation + Auto Snapshot trigger
# Part of Skill Orchestrator Beast Mode
# Paths updated 2026-08-01: skills live under server-skills + workspace + custom user dir
# Polished: graceful VCS handoff, clean non-git behavior

echo "=== Bulk Skill Validation ==="
echo "Timestamp: $(date)"
echo ""

FAIL_COUNT=0
PASS_COUNT=0

# Prefer server-skills validate script; fall back to legacy /root/.grok/skills path
VALIDATOR=""
for cand in \
  /root/.grok/server-skills/skill-creator/scripts/validate-skill.sh \
  /root/.grok/skills/skill-creator/scripts/validate-skill.sh \
  /home/workdir/.grok/skills/skill-creator/scripts/validate-skill.sh; do
  if [ -f "$cand" ]; then
    VALIDATOR="$cand"
    break
  fi
done

if [ -z "$VALIDATOR" ]; then
  echo "ERROR: validate-skill.sh not found"
  exit 2
fi

validate_tree() {
  local label="$1"
  local root="$2"
  echo "$label ($root):"
  if [ ! -d "$root" ]; then
    echo "  (missing — skip)"
    echo ""
    return
  fi
  local found=0
  for skill in "$root"/*/; do
    [ -d "$skill" ] || continue
    [ -f "${skill}SKILL.md" ] || continue
    found=1
    name=$(basename "$skill")
    result=$("$VALIDATOR" "$skill" 2>&1) || true
    if echo "$result" | grep -q "^OK:"; then
      echo "  OK  $name"
      PASS_COUNT=$((PASS_COUNT + 1))
    else
      echo "  FAIL $name"
      echo "$result" | head -3 | sed 's/^/    /'
      FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
  done
  if [ "$found" -eq 0 ]; then
    echo "  (no skills with SKILL.md)"
  fi
  echo ""
}

# Roots actually present in current sandboxes
validate_tree "Server skills" "/root/.grok/server-skills"
validate_tree "Bundled skills" "/root/.grok/skills"
validate_tree "Custom skills" "/home/workdir/.grok/skills"
validate_tree "Workspace app skills" "/workspace/.grok/skills"

echo "Validation complete. Pass: $PASS_COUNT  Failures: $FAIL_COUNT"

# Fast WASM pre-scan / integrity (non-blocking if missing)
for HARNESS in \
  /root/.grok/server-skills/skill-orchestrator/scripts/wasm-validate-harness.mjs \
  /home/workdir/.grok/skills/skill-orchestrator/scripts/wasm-validate-harness.mjs; do
  if [ -f "$HARNESS" ]; then
    echo ""
    echo "=== WASM harness (speed path) ==="
    mkdir -p /home/workdir/artifacts /workspace/artifacts 2>/dev/null || true
    node "$HARNESS" 2>&1 || true
    break
  fi
done

# Spicy unit tests when present
for SPICY in \
  /root/.grok/server-skills/skill-orchestrator/scripts/spicy-error-unit-tests.mjs \
  /home/workdir/.grok/skills/skill-orchestrator/scripts/spicy-error-unit-tests.mjs; do
  if [ -f "$SPICY" ]; then
    echo ""
    echo "=== Spicy error unit tests ==="
    node "$SPICY" 2>&1 || true
    break
  fi
done

# Automated snapshot trigger (best-effort)
if [ "$FAIL_COUNT" -eq 0 ]; then
  echo ""
  echo "=== Auto-snapshot trigger (clean validation) ==="
  for VCS in \
    /root/.grok/server-skills/skill-orchestrator/scripts/skill-vcs.sh \
    /home/workdir/.grok/skills/skill-orchestrator/scripts/skill-vcs.sh; do
    if [ -x "$VCS" ] || [ -f "$VCS" ]; then
      bash "$VCS" auto "post-bulk-validate" 2>&1 || true
      break
    fi
  done
  if [ ! -f /root/.grok/server-skills/skill-orchestrator/scripts/skill-vcs.sh ] \
     && [ ! -f /home/workdir/.grok/skills/skill-orchestrator/scripts/skill-vcs.sh ]; then
    echo "  (skill-vcs.sh not present — skip snapshot)"
  fi
else
  echo ""
  echo "=== Skipping auto-snapshot (validation had failures) ==="
fi

exit "$FAIL_COUNT"
