#!/usr/bin/env bash
# PKE CI skill validator — repo-native, GitHub Actions safe
# Scans every directory with SKILL.md under the repo root (depth 1–2).
# Uses skill-creator/scripts/validate-skill.sh when present; falls back to structural checks.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

VALIDATE=""
if [[ -x "$ROOT/skill-creator/scripts/validate-skill.sh" ]]; then
  VALIDATE="$ROOT/skill-creator/scripts/validate-skill.sh"
elif [[ -f "$ROOT/skill-creator/scripts/validate-skill.sh" ]]; then
  VALIDATE="$ROOT/skill-creator/scripts/validate-skill.sh"
fi

PASS=0
FAIL=0
FAILED_NAMES=""

echo "=== PKE CI skill validate ==="
echo "ROOT=$ROOT"
echo "VALIDATE=${VALIDATE:-structural-fallback}"
echo "TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo ""

# Collect skill dirs into a temp file (portable; no process substitution)
LIST_FILE=$(mktemp)
find "$ROOT" -mindepth 2 -maxdepth 3 -type f -name 'SKILL.md' \
  ! -path '*/node_modules/*' \
  ! -path '*/.git/*' \
  ! -path '*/_archived/*' \
  2>/dev/null | sed 's|/SKILL.md$||' | sort -u > "$LIST_FILE" || true

while IFS= read -r d; do
  [ -n "$d" ] || continue
  name=$(basename "$d")
  rel=${d#"$ROOT/"}
  if [ -n "$VALIDATE" ]; then
    out=$(bash "$VALIDATE" "$d" 2>&1) || true
    if echo "$out" | grep -q "^OK:"; then
      echo "OK   $rel"
      PASS=$((PASS+1))
    else
      echo "FAIL $rel"
      echo "$out" | head -5 | sed 's/^/     /'
      FAIL=$((FAIL+1))
      FAILED_NAMES="$FAILED_NAMES $rel"
    fi
  else
    ok=1
    if [ ! -f "$d/SKILL.md" ]; then ok=0; fi
    if ! head -1 "$d/SKILL.md" | grep -q '^---$'; then ok=0; fi
    name_line=$(grep -m1 '^name:' "$d/SKILL.md" || true)
    desc_line=$(grep -m1 '^description:' "$d/SKILL.md" || true)
    [ -n "$name_line" ] && [ -n "$desc_line" ] || ok=0
    raw_name=${name_line#name:}
    raw_name=$(echo "$raw_name" | sed 's/^[[:space:]]*//')
    if [ "$raw_name" != "$name" ]; then ok=0; fi
    dlen=$(echo "${desc_line#description:}" | wc -c)
    if [ "$dlen" -gt 1024 ]; then ok=0; fi
    if [ $ok -eq 1 ]; then
      echo "OK   $rel (fallback)"
      PASS=$((PASS+1))
    else
      echo "FAIL $rel (fallback)"
      FAIL=$((FAIL+1))
      FAILED_NAMES="$FAILED_NAMES $rel"
    fi
  fi
done < "$LIST_FILE"
rm -f "$LIST_FILE"

# Podcast studio local extras
if [ -x "$ROOT/covicea-pke-podcast-studio/scripts/validate-local.sh" ] || [ -f "$ROOT/covicea-pke-podcast-studio/scripts/validate-local.sh" ]; then
  echo ""
  echo "=== Podcast studio local validate ==="
  if bash "$ROOT/covicea-pke-podcast-studio/scripts/validate-local.sh"; then
    echo "OK   covicea-pke-podcast-studio/validate-local"
  else
    echo "FAIL covicea-pke-podcast-studio/validate-local"
    FAIL=$((FAIL+1))
    FAILED_NAMES="$FAILED_NAMES covicea-pke-podcast-studio/validate-local"
  fi
fi

# Mind state presence (permanent activation stamp)
echo ""
echo "=== Permanent activation stamps ==="
if [ -f "$ROOT/mind/state.json" ]; then
  if grep -q 'covicea-pke-podcast-studio' "$ROOT/mind/state.json" \
     || grep -q 'podcast_studio' "$ROOT/mind/state.json"; then
    echo "OK   mind/state.json references podcast studio"
  else
    echo "WARN mind/state.json missing podcast studio key (non-fatal)"
  fi
else
  echo "WARN mind/state.json missing (non-fatal)"
fi

if [ -f "$ROOT/config/permanent-activation.json" ]; then
  echo "OK   config/permanent-activation.json present"
else
  echo "WARN config/permanent-activation.json missing (non-fatal)"
fi

echo ""
echo "PASS=$PASS FAIL=$FAIL"
if [ "$FAIL" -gt 0 ]; then
  echo "Failed:$FAILED_NAMES"
  exit 1
fi
echo "STATUS=HEALTHY"
exit 0
