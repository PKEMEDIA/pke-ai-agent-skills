#!/usr/bin/env bash
# Empire OS — structural validate all skills under a skills root
set -euo pipefail
ROOT="${1:-${HOME}/.grok/skills}"
VALIDATE="${VALIDATE_SCRIPT:-/root/.grok/skills/skill-creator/scripts/validate-skill.sh}"
PASS=0; FAIL=0
echo "=== empire-validate ROOT=$ROOT ==="
for d in "$ROOT"/*/; do
  [[ -d "$d" ]] || continue
  name=$(basename "$d")
  [[ -f "${d}SKILL.md" ]] || continue
  out=$(bash "$VALIDATE" "$d" 2>&1) || true
  if echo "$out" | grep -q "^OK:"; then PASS=$((PASS+1)); echo "OK   $name"
  else FAIL=$((FAIL+1)); echo "FAIL $name"; fi
done
echo "PASS=$PASS FAIL=$FAIL"
(( FAIL == 0 ))
