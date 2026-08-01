#!/bin/bash
# Checks that SKILL.md starts with valid YAML frontmatter
SKILL_MD="${1:-SKILL.md}"
if [ ! -f "$SKILL_MD" ]; then
  echo "No SKILL.md"
  exit 1
fi
# Simple check: must start with --- and contain name: + description:
head -20 "$SKILL_MD" | grep -q "^---" && \
head -30 "$SKILL_MD" | grep -q "name:" && \
head -30 "$SKILL_MD" | grep -q "description:" 
