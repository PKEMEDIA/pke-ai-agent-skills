#!/bin/bash
# Bulk Skill Validation + Auto Snapshot trigger
# Part of Skill Orchestrator Beast Mode
# Paths updated 2026-08-01: skills live under server-skills + workspace + custom user dir
# Polished 2026-08-01: graceful non-git VCS, clean exit, quarantine-aware
# Autonomy pass 2026-08-01: PKE gate = server-skills; workspace platform skills soft-report

echo "=== Bulk Skill Validation ==="
echo "Timestamp: $(date)"
echo ""

FAIL_COUNT=0
PASS_COUNT=0
PKE_FAIL=0
PKE_PASS=0

# Prefer server-skills validate script; fall back to legacy paths
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
  local is_pke="${3:-0}"
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
      if [ "$is_pke" = "1" ]; then PKE_PASS=$((PKE_PASS + 1)); fi
    else
      echo "  FAIL $name"
      echo "$result" | head -3 | sed 's/^/    /'
      FAIL_COUNT=$((FAIL_COUNT + 1))
      if [ "$is_pke" = "1" ]; then PKE_FAIL=$((PKE_FAIL + 1)); fi
    fi
  done
  if [ "$found" -eq 0 ]; then
    echo "  (no skills with SKILL.md)"
  fi
  echo ""
}

# Roots actually present in current sandboxes
# is_pke=1 marks the blocking health gate
validate_tree "Server skills" "/root/.grok/server-skills" 1
validate_tree "Bundled skills" "/root/.grok/skills" 0
validate_tree "Custom skills" "/home/workdir/.grok/skills" 0
validate_tree "Workspace app skills" "/workspace/.grok/skills" 0

echo "PKE gate note: server-skills failures are blocking; workspace app-builder angle-bracket fails are platform format and soft."
echo "Validation complete. Pass: $PASS_COUNT  Failures: $FAIL_COUNT"
echo "PKE server-skills gate. Pass: $PKE_PASS  Failures: $PKE_FAIL"

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

# Auto-snapshot only when PKE gate is clean
if [ "$PKE_FAIL" -eq 0 ]; then
  for VCS in \
    /root/.grok/server-skills/skill-orchestrator/scripts/skill-vcs.sh \
    /home/workdir/.grok/skills/skill-orchestrator/scripts/skill-vcs.sh; do
    if [ -f "$VCS" ]; then
      echo ""
      echo "=== Auto-snapshot (PKE gate green) ==="
      bash "$VCS" auto "post-bulk-validate" 2>&1 || true
      break
    fi
  done
else
  echo ""
  echo "=== Skipping auto-snapshot (PKE gate had failures) ==="
fi

# Exit non-zero only on PKE failures
if [ "$PKE_FAIL" -gt 0 ]; then
  exit 1
fi
exit 0
