#!/usr/bin/env bash
# Grok Build PostToolUse hook → Make.com Voice Commander webhook
# Place at: ~/.grok/hooks/ OR project .grok/hooks/
# Event JSON on stdin. Never hardcode webhook secrets in git.
set -euo pipefail

EVENT=$(cat || true)
MAKE_WEBHOOK_URL="${MAKE_WEBHOOK_URL:-}"

if [[ -z "$MAKE_WEBHOOK_URL" ]]; then
  exit 0
fi

TOOL=$(echo "$EVENT" | jq -r '.tool // .name // empty' 2>/dev/null || true)
STATUS=$(echo "$EVENT" | jq -r '.status // .result // "ok"' 2>/dev/null || true)

case "$TOOL" in
  Write|Edit|Bash|write_file|edit_file) ;;
  *) exit 0 ;;
esac

PAYLOAD=$(jq -n \
  --arg cmd "post_tool_use" \
  --arg scenario "automation_log" \
  --arg source "grok-build-hook" \
  --arg tool "$TOOL" \
  --arg status "$STATUS" \
  '{command:$cmd,scenario:$scenario,source:$source,notion_db:"automation-log",data:{tool:$tool,status:$status},timestamp:(now|todateiso8601)}' 2>/dev/null \
  || echo '{"command":"post_tool_use","scenario":"automation_log","source":"grok-build-hook"}')

curl -sS -m 8 -X POST "$MAKE_WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD" >/dev/null 2>&1 || true

exit 0
