#!/usr/bin/env bash
# Grok Build PostToolUse → Make.com Voice Commander (Scenario 5)
# Install: cp to ~/.grok/hooks/ or project .grok/hooks/ ; chmod +x
# Requires: MAKE_WEBHOOK_URL in env (never commit secrets)
set -euo pipefail

EVENT=$(cat || true)
MAKE_WEBHOOK_URL="${MAKE_WEBHOOK_URL:-}"
[[ -n "$MAKE_WEBHOOK_URL" ]] || exit 0

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

TOOL=$(echo "$EVENT" | jq -r '.tool // .name // .toolName // empty' 2>/dev/null || true)
STATUS=$(echo "$EVENT" | jq -r '.status // .result // "ok"' 2>/dev/null || true)
PATH_HINT=$(echo "$EVENT" | jq -r '.path // .file // .filePath // .input.path // empty' 2>/dev/null || true)
RAW=$(echo "$EVENT" | jq -c '.' 2>/dev/null || echo '{}')

# Only care about write-like / significant tools
case "$TOOL" in
  Write|Edit|Bash|write_file|edit_file|WriteFile|EditFile|search_replace|StrReplace) ;;
  *) exit 0 ;;
esac

SCENARIO="automation_log"
NOTION_DB="automation-log"
case "$PATH_HINT" in
  *legal*|*Legal*|*affidavit*|*claim*) SCENARIO="legal"; NOTION_DB="legal-tracker" ;;
  *covicea*|*COVICEA*|*Distraction*|*album*) SCENARIO="covicea"; NOTION_DB="covicea-visual-log" ;;
  *content*|*calendar*|*episode*) SCENARIO="content"; NOTION_DB="content-strategy" ;;
esac

PAYLOAD=$(jq -n \
  --arg cmd "post_tool_use" \
  --arg scenario "$SCENARIO" \
  --arg source "grok-build-hook" \
  --arg tool "$TOOL" \
  --arg status "$STATUS" \
  --arg path "$PATH_HINT" \
  --argjson event "$RAW" \
  --arg db "$NOTION_DB" \
  '{
    command: $cmd,
    scenario: $scenario,
    source: $source,
    notion_db: $db,
    data: {tool: $tool, status: $status, path: $path, event: $event},
    timestamp: (now | todateiso8601)
  }')

curl -sS -m 8 -X POST "$MAKE_WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD" >/dev/null 2>&1 || true

exit 0
