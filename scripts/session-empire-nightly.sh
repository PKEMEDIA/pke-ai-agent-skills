#!/usr/bin/env bash
set -euo pipefail
export XAI_API_KEY="${XAI_API_KEY:?missing XAI_API_KEY}"
SESSION="${SESSION_ID:-empire-nightly}"
grok --no-auto-update \
  -s "$SESSION" \
  -p "${1:-Draft weekly Empire OS summary: podcast, legal deadlines, COVICEA visual log, content calendar. Consenting adults only; legal drafts attorney-ready.}" \
  --output-format streaming-json \
  --always-approve
