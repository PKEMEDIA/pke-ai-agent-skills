#!/usr/bin/env bash
# Stateful Empire OS nightly summary session
set -euo pipefail
export XAI_API_KEY="${XAI_API_KEY:?missing XAI_API_KEY}"
SESSION="${SESSION_ID:-empire-nightly}"
PROMPT="${1:-Draft weekly Empire OS summary: podcast, legal deadlines, COVICEA visual log, content calendar. Consenting adults only; legal drafts attorney-ready not templates.}"

grok --no-auto-update \
  -s "$SESSION" \
  -p "$PROMPT" \
  --output-format streaming-json \
  --always-approve
