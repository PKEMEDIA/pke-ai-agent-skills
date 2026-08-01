#!/bin/bash
# Continuous Testing Loop with VCS + Bisect Integration
# Skill Orchestrator - Beast Mode
# Usage: ./continuous-testing-loop.sh [max_iterations] [--bisect-on-fail]

set -e

SKILLS_ROOT="/home/workdir/.grok/skills"
SCRIPTS="$SKILLS_ROOT/skill-orchestrator/scripts"
VALIDATE="/root/.grok/skills/skill-creator/scripts/validate-skill.sh"
MAX_ITER=${1:-3}
BISECT_ON_FAIL=false
[[ "$*" == *"--bisect-on-fail"* ]] && BISECT_ON_FAIL=true

cd "$SKILLS_ROOT" || exit 1

echo "╔══════════════════════════════════════════════════════╗"
echo "║   Continuous Testing Loop - Skill Orchestrator       ║"
echo "║   Max iterations: $MAX_ITER   Bisect-on-fail: $BISECT_ON_FAIL"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

ITERATION=0
OVERALL_PASS=true

while [ $ITERATION -lt $MAX_ITER ]; do
  ITERATION=$((ITERATION + 1))
  echo "──────────────────────────────────────────────────────"
  echo "▶ Iteration $ITERATION / $MAX_ITER  $(date '+%H:%M:%S')"
  echo "──────────────────────────────────────────────────────"

  FAIL_COUNT=0
  FAILED_SKILLS=()

  # 1. Structural validation of all custom skills
  echo "→ Running structural validation..."
  for skill_dir in "$SKILLS_ROOT"/*/; do
    if [ -f "${skill_dir}SKILL.md" ]; then
      name=$(basename "$skill_dir")
      result=$($VALIDATE "$skill_dir" 2>&1)
      if echo "$result" | grep -qE "FAIL|ERROR"; then
        echo "  ✗ $name"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        FAILED_SKILLS+=("$name")
        OVERALL_PASS=false
      fi
    fi
  done

  if [ $FAIL_COUNT -eq 0 ]; then
    echo "  ✓ All skills structurally valid"
  else
    echo "  ✗ $FAIL_COUNT skill(s) failed: ${FAILED_SKILLS[*]}"
  fi

  # 2. Auto-snapshot on clean validation
  if [ $FAIL_COUNT -eq 0 ]; then
    echo "→ Triggering auto-snapshot..."
    "$SCRIPTS/skill-vcs.sh" auto "post-loop-iter-$ITERATION" || true
  fi

  # 3. If failures and bisect requested, offer/run bisect on first failure
  if [ $FAIL_COUNT -gt 0 ] && [ "$BISECT_ON_FAIL" = true ]; then
    FIRST_FAIL="${FAILED_SKILLS[0]}"
    echo ""
    echo "→ Bisect-on-fail activated for: $FIRST_FAIL"
    # Find a reasonable known-good (previous commit or baseline)
    KNOWN_GOOD=$(git log --oneline -5 | tail -1 | awk '{print $1}')
    echo "  Using known-good candidate: $KNOWN_GOOD"
    echo "  (Run manually for full control: $SCRIPTS/bisect-skill.sh $KNOWN_GOOD $FIRST_FAIL)"
    # We do not auto-run the full bisect here to avoid long blocking;
    # instead we prepare the command and log it.
  fi

  # 4. Simple limit check (flag large skills)
  echo "→ Quick limit scan..."
  LARGE=$(find "$SKILLS_ROOT" -name "SKILL.md" -exec wc -l {} + 2>/dev/null | awk '$1 > 300 {print $2}' | xargs -n1 basename 2>/dev/null | tr '\n' ' ')
  if [ -n "$LARGE" ]; then
    echo "  ⚠ Skills >300 lines: $LARGE"
  else
    echo "  ✓ No oversized SKILL.md bodies"
  fi

  echo ""
  if [ $FAIL_COUNT -eq 0 ]; then
    echo "✓ Iteration $ITERATION passed cleanly"
    # Early exit on full success
    break
  else
    echo "✗ Iteration $ITERATION had failures — continuing..."
  fi
done

echo ""
echo "╔══════════════════════════════════════════════════════╗"
if [ "$OVERALL_PASS" = true ]; then
  echo "║   LOOP COMPLETE — ALL CLEAR                          ║"
else
  echo "║   LOOP FINISHED WITH REMAINING ISSUES                ║"
  echo "║   Failed skills: ${FAILED_SKILLS[*]}"
fi
echo "╚══════════════════════════════════════════════════════╝"
echo ""
echo "Next actions:"
echo "  • Review failed skills and run: $SCRIPTS/bisect-skill.sh <good> <skill>"
echo "  • Or run full status: $SCRIPTS/skill-vcs.sh status"
echo "  • Dashboard: see references/continuous-testing-loop.md"
