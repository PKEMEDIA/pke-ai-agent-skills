#!/bin/bash
# Flags extremely narrow or missing description
SKILL_MD="${1:-SKILL.md}"
DESC=$(sed -n '/^description:/,/^[a-z]/p' "$SKILL_MD" | head -5)
if [ -z "$DESC" ]; then
  echo "Missing description"
  exit 1
fi
# Very crude length check - real quality is more nuanced
WORD_COUNT=$(echo "$DESC" | wc -w)
if [ "$WORD_COUNT" -lt 8 ]; then
  echo "Description too short / narrow"
  exit 1
fi
exit 0
