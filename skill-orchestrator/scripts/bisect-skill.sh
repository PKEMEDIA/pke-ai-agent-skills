#!/bin/bash
# High-level automated bisect for skills + presets
# Usage:
#   ./bisect-skill.sh <known-good-commit> <skill-name> [--preset structural|frontmatter|trigger|demo]
#   ./bisect-skill.sh <known-good-commit> --demo

SKILLS_ROOT="/home/workdir/.grok/skills"
SCRIPTS="$SKILLS_ROOT/skill-orchestrator/scripts"
TESTS="$SCRIPTS/bisect-tests"
cd "$SKILLS_ROOT" || exit 1

GOOD_COMMIT="$1"
TARGET="$2"
PRESET="structural"   # default

# Parse optional preset
for arg in "$@"; do
  case "$arg" in
    --preset=*) PRESET="${arg#*=}" ;;
    --structural) PRESET="structural" ;;
    --frontmatter) PRESET="frontmatter" ;;
    --trigger) PRESET="trigger" ;;
    --demo) PRESET="demo" ;;
  esac
done

if [ -z "$GOOD_COMMIT" ]; then
  echo "Usage: $0 <known-good-commit> <skill-name|--demo> [--preset structural|frontmatter|trigger|demo]"
  echo ""
  echo "Presets:"
  echo "  structural   - full validate-skill.sh (default)"
  echo "  frontmatter  - YAML frontmatter integrity"
  echo "  trigger      - basic description/trigger quality"
  echo "  demo         - built-in demo status test"
  exit 1
fi

if [ "$TARGET" = "--demo" ] || [ "$PRESET" = "demo" ]; then
  echo "=== Automated Bisect (Demo Mode) ==="
  TEST_CMD="$TESTS/test-demo-status.sh"
elif [ -n "$TARGET" ] && [ "$TARGET" != "--demo" ]; then
  SKILL_PATH="$SKILLS_ROOT/$TARGET"
  if [ ! -d "$SKILL_PATH" ]; then
    echo "Skill not found: $TARGET"
    exit 1
  fi
  echo "=== Automated Bisect for skill: $TARGET (preset: $PRESET) ==="
  case "$PRESET" in
    structural)
      TEST_CMD="/root/.grok/skills/skill-creator/scripts/validate-skill.sh $SKILL_PATH"
      ;;
    frontmatter)
      TEST_CMD="$TESTS/test-frontmatter.sh $SKILL_PATH/SKILL.md"
      ;;
    trigger)
      TEST_CMD="$TESTS/test-trigger-quality.sh $SKILL_PATH/SKILL.md"
      ;;
    *)
      echo "Unknown preset: $PRESET"
      exit 1
      ;;
  esac
else
  echo "Missing skill name or --demo"
  exit 1
fi

echo "Known good : $GOOD_COMMIT"
echo "Test       : $TEST_CMD"
echo ""

git bisect start
git bisect bad HEAD
git bisect good "$GOOD_COMMIT"

echo "Running fully automated search..."
git bisect run bash -c "$TEST_CMD"

echo ""
echo "=== Bisect finished ==="
git bisect log | tail -10
echo ""
git bisect reset
echo "Returned to original branch."
