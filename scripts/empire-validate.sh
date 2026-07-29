#!/usr/bin/env bash
# Empire OS — structural validate all skills under a skills root
# Does NOT require XAI_API_KEY. Uses validate-skill.sh when available.
set -euo pipefail
ROOT="${1:-${HOME}/.grok/skills}"

# Resolve validate-skill.sh from common locations
if [[ -n "${VALIDATE_SCRIPT:-}" && -x "$VALIDATE_SCRIPT" ]]; then
  VALIDATE="$VALIDATE_SCRIPT"
elif [[ -x /root/.grok/server-skills/skill-creator/scripts/validate-skill.sh ]]; then
  VALIDATE=/root/.grok/server-skills/skill-creator/scripts/validate-skill.sh
elif [[ -x /root/.grok/skills/skill-creator/scripts/validate-skill.sh ]]; then
  VALIDATE=/root/.grok/skills/skill-creator/scripts/validate-skill.sh
elif [[ -x "$ROOT/skill-creator/scripts/validate-skill.sh" ]]; then
  VALIDATE="$ROOT/skill-creator/scripts/validate-skill.sh"
elif command -v validate-skill.sh >/dev/null 2>&1; then
  VALIDATE=$(command -v validate-skill.sh)
else
  echo "ERROR: validate-skill.sh not found. Set VALIDATE_SCRIPT=..." >&2
  exit 2
fi

PASS=0; FAIL=0
echo "=== empire-validate ROOT=$ROOT ==="
echo "=== using $VALIDATE ==="
for d in "$ROOT"/*/; do
  [[ -d "$d" ]] || continue
  name=$(basename "$d")
  [[ -f "${d}SKILL.md" ]] || continue
  out=$(bash "$VALIDATE" "$d" 2>&1) || true
  if echo "$out" | grep -q "^OK:"; then
    PASS=$((PASS+1))
    echo "OK   $name"
  else
    FAIL=$((FAIL+1))
    echo "FAIL $name"
    echo "     $out" | head -3
  fi
done
echo "PASS=$PASS FAIL=$FAIL TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
(( FAIL == 0 ))
