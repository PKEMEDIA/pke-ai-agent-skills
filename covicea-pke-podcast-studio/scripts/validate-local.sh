#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fail=0
test -f "$ROOT/SKILL.md" || { echo "FAIL: missing SKILL.md"; fail=1; }
# frontmatter checks
desc_line=$(grep -E '^description:' "$ROOT/SKILL.md" | head -1)
name_line=$(grep -E '^name:' "$ROOT/SKILL.md" | head -1)
echo "$name_line" | grep -q 'covicea-pke-podcast-studio' || { echo "FAIL: name mismatch"; fail=1; }
# description length (approx chars after description:)
dlen=$(echo "$desc_line" | sed 's/^description: //' | wc -c)
if [ "$dlen" -gt 1024 ]; then echo "FAIL: description too long ($dlen)"; fail=1; fi
# required refs
for f in orchestration-patterns.md episode-bible.md activation-playbook.md; do
  test -f "$ROOT/references/$f" || { echo "FAIL: missing references/$f"; fail=1; }
done
# lean body preference
lines=$(wc -l < "$ROOT/SKILL.md")
if [ "$lines" -gt 200 ]; then echo "WARN: SKILL.md $lines lines (prefer progressive disclosure)"; fi
if [ "$fail" -eq 0 ]; then echo "OK: covicea-pke-podcast-studio local validate pass ($lines lines, desc~$dlen chars)"; exit 0; fi
exit 1
