#!/bin/bash
# Exit 0 if skill validates, 1 otherwise
# Usage: test-structural.sh /path/to/skill-dir
SKILL_DIR="${1:-.}"
/root/.grok/skills/skill-creator/scripts/validate-skill.sh "$SKILL_DIR" >/dev/null 2>&1
