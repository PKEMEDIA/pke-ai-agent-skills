#!/usr/bin/env bash
# PKE CI skill validator — repo-native, GitHub Actions safe, parallel-capable
# Scans every directory with SKILL.md under the repo root (depth 1–2).
# Uses skill-creator/scripts/validate-skill.sh when present; falls back to structural checks.
# Parallel via CI_VALIDATE_JOBS (default 4). Per-skill status files make aggregation
# authoritative — no sequential re-run.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

VALIDATE=""
if [[ -x "$ROOT/skill-creator/scripts/validate-skill.sh" ]]; then
  VALIDATE="$ROOT/skill-creator/scripts/validate-skill.sh"
elif [[ -f "$ROOT/skill-creator/scripts/validate-skill.sh" ]]; then
  VALIDATE="$ROOT/skill-creator/scripts/validate-skill.sh"
fi

JOBS="${CI_VALIDATE_JOBS:-4}"
PASS=0
FAIL=0
FAILED_NAMES=""

echo "=== PKE CI skill validate ==="
echo "ROOT=$ROOT"
echo "VALIDATE=${VALIDATE:-structural-fallback}"
echo "JOBS=$JOBS"
echo "TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo ""

# Collect skill dirs into a temp file (portable; no process substitution)
LIST_FILE=$(mktemp)
STATUS_DIR=$(mktemp -d)
trap 'rm -f "$LIST_FILE"; rm -rf "$STATUS_DIR"' EXIT

find "$ROOT" -mindepth 2 -maxdepth 3 -type f -name 'SKILL.md' \
  ! -path '*/node_modules/*' \
  ! -path '*/.git/*' \
  ! -path '*/_archived/*' \
  2>/dev/null | sed 's|/SKILL.md$||' | sort -u > "$LIST_FILE" || true

SKILL_COUNT=$(wc -l < "$LIST_FILE" | tr -d ' ')
echo "SKILLS_FOUND=$SKILL_COUNT"
echo ""

# Human-facing validate (prints OK/FAIL lines; may interleave under -P)
validate_one() {
  local d="$1"
  local name rel out ok=1
  name=$(basename "$d")
  rel=${d#"$ROOT/"}
  if [ -n "$VALIDATE" ]; then
    out=$(bash "$VALIDATE" "$d" 2>&1) || true
    if echo "$out" | grep -q "^OK:"; then
      echo "OK   $rel"
      return 0
    else
      echo "FAIL $rel"
      echo "$out" | head -5 | sed 's/^/     /'
      return 1
    fi
  else
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
      return 0
    else
      echo "FAIL $rel (fallback)"
      return 1
    fi
  fi
}

# Atomic per-skill status file (no interleaving / no flock needed)
# Format: PASS|name|rel  or  FAIL|name|rel
run_one() {
  local d="$1"
  local name rel key
  name=$(basename "$d")
  rel=${d#"$ROOT/"}
  # sha256 of rel → unique key even when basename collides (skills-live vs top-level)
  key=$(printf '%s' "$rel" | sha256sum | awk '{print $1}')
  if validate_one "$d"; then
    printf 'PASS|%s|%s\n' "$name" "$rel" > "$STATUS_DIR/$key"
  else
    printf 'FAIL|%s|%s\n' "$name" "$rel" > "$STATUS_DIR/$key"
  fi
}

export -f validate_one run_one
export ROOT VALIDATE STATUS_DIR

if [ "$SKILL_COUNT" -eq 0 ]; then
  echo "WARN no SKILL.md found (non-fatal for empty trees)"
elif command -v xargs >/dev/null 2>&1 && [ "$JOBS" -gt 1 ]; then
  # Parallel path — results live in STATUS_DIR (authoritative)
  # GNU xargs -a (ubuntu-latest). Exit status ignored; we count files below.
  xargs -P "$JOBS" -a "$LIST_FILE" -I {} bash -c 'run_one "$@"' _ {} || true
else
  # Sequential path (JOBS=1 or no xargs)
  while IFS= read -r d; do
    [ -n "$d" ] || continue
    run_one "$d" || true
  done < "$LIST_FILE"
fi

# Aggregate from status files only (single source of truth)
for f in "$STATUS_DIR"/*; do
  [ -f "$f" ] || continue
  line=$(cat "$f")
  status=${line%%|*}
  rest=${line#*|}
  name=${rest%%|*}
  if [ "$status" = "PASS" ]; then
    PASS=$((PASS + 1))
  else
    FAIL=$((FAIL + 1))
    FAILED_NAMES="$FAILED_NAMES $name"
  fi
done

# Permanent activation stamps (cheap presence checks)
# Podcast local gate lives in the workflow step only (no double-run).
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
