#!/bin/bash
# Mac/local bulk validate for PKE skill ecosystem (Grok Build CLI host)
set -uo pipefail
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CLI_SKILLS="${HOME}/.grok/skills"
BUNDLED="${HOME}/.grok/bundled/skills"
ARTIFACTS="${REPO_ROOT}/artifacts"
mkdir -p "$ARTIFACTS"

VALIDATOR=""
for cand in \
  "$CLI_SKILLS/skill-creator/scripts/validate-skill.sh" \
  "$REPO_ROOT/skill-creator/scripts/validate-skill.sh"; do
  if [ -f "$cand" ]; then VALIDATOR="$cand"; break; fi
done
if [ -z "$VALIDATOR" ]; then
  echo "ERROR: validate-skill.sh not found"; exit 2
fi

# Consensus gate — same entrypoint as PKE Skill CI / Super Mind deploy
GATE_SH=""
for cand in   "${REPO_ROOT}/scripts/consensus-gate.sh"   "${REPO_ROOT}/skill-orchestrator/scripts/consensus-gate.sh"
do
  if [ -f "$cand" ]; then GATE_SH="$cand"; break; fi
done
if [ -n "$GATE_SH" ]; then
  echo "=== Consensus heal gate (Mac terminal) ==="
  # Full gate+suite like CI so Mac deploy matches GitHub
  bash "$GATE_SH" || { echo "ERROR: consensus gate failed"; exit 1; }
  echo ""
fi

echo "=== Bulk Skill Validation (Mac) ==="
echo "Timestamp: $(date)"
echo "Validator: $VALIDATOR"
echo ""

FAIL_COUNT=0; PASS_COUNT=0
PKE_FAIL=0; PKE_PASS=0

validate_tree() {
  local label="$1" root="$2" is_pke="${3:-0}"
  echo "$label ($root):"
  if [ ! -d "$root" ]; then echo "  (missing — skip)"; echo ""; return; fi
  local found=0
  for skill in "$root"/*/; do
    [ -d "$skill" ] || continue
    [ -f "${skill}SKILL.md" ] || continue
    # skip non-skill package dirs at repo root
    name=$(basename "$skill")
    case "$name" in
      agents|artifacts|comfyui|config|deploy|docs|hooks|mind|scripts|skills-live|.git|.grok) continue ;;
    esac
    found=1
    result=$("$VALIDATOR" "$skill" 2>&1) || true
    if echo "$result" | grep -q "^OK:"; then
      echo "  OK  $name"
      PASS_COUNT=$((PASS_COUNT + 1))
      [ "$is_pke" = "1" ] && PKE_PASS=$((PKE_PASS + 1))
    else
      echo "  FAIL $name"
      echo "$result" | head -2 | sed 's/^/    /'
      FAIL_COUNT=$((FAIL_COUNT + 1))
      [ "$is_pke" = "1" ] && PKE_FAIL=$((PKE_FAIL + 1))
    fi
  done
  [ "$found" -eq 0 ] && echo "  (no skills with SKILL.md)"
  echo ""
}

validate_tree "skills-live (PKE user skills)" "$REPO_ROOT/skills-live" 1
validate_tree "repo-root PKE skills" "$REPO_ROOT" 1
validate_tree "CLI ~/.grok/skills" "$CLI_SKILLS" 0
validate_tree "bundled" "$BUNDLED" 0

echo "Validation complete. Pass: $PASS_COUNT  Failures: $FAIL_COUNT"
echo "PKE gate. Pass: $PKE_PASS  Failures: $PKE_FAIL"

HARNESS="$REPO_ROOT/skill-orchestrator/scripts/wasm-validate-harness.mjs"
if [ -f "$HARNESS" ]; then
  echo ""
  echo "=== WASM harness (skills-live) ==="
  node "$HARNESS" --root "$REPO_ROOT/skills-live" --json "$ARTIFACTS/validation-report.json" 2>&1 || true
fi

SPICY="$REPO_ROOT/skill-orchestrator/scripts/spicy-error-unit-tests.mjs"
if [ -f "$SPICY" ]; then
  echo ""
  echo "=== Spicy error unit tests ==="
  if [ ! -e "$REPO_ROOT/spicy-male-erotic-prompt-optimizer" ] && [ -d "$REPO_ROOT/skills-live/spicy-male-erotic-prompt-optimizer" ]; then
    ln -sfn skills-live/spicy-male-erotic-prompt-optimizer "$REPO_ROOT/spicy-male-erotic-prompt-optimizer"
  fi
  node "$SPICY" 2>&1 || true
fi

if [ "$PKE_FAIL" -gt 0 ]; then exit 1; fi
exit 0
