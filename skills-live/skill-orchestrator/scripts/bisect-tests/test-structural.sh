#!/bin/bash
# Exit 0 if skill validates, 1 otherwise
# Usage: test-structural.sh /path/to/skill-dir
SKILL_DIR="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VAL=""
for c in \
  "${PKE_ROOT:-}/skill-creator/scripts/validate-skill.sh" \
  "$HOME/.grok/skills/skill-creator/scripts/validate-skill.sh" \
  "$SCRIPT_DIR/../../../skill-creator/scripts/validate-skill.sh"
do
  if [ -n "$c" ] && [ -f "$c" ]; then
    VAL="$c"
    break
  fi
done
if [ -z "$VAL" ]; then
  echo "validate-skill.sh not found (set PKE_ROOT)" >&2
  exit 1
fi
bash "$VAL" "$SKILL_DIR" >/dev/null 2>&1
