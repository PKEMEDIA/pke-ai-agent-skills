#!/usr/bin/env bash
# One-shot headless Grok Build prompt → JSON
set -euo pipefail
export XAI_API_KEY="${XAI_API_KEY:?missing XAI_API_KEY}"
PROMPT="${1:-Explain this codebase in 5 bullets}"

grok --no-auto-update \
  -p "$PROMPT" \
  --output-format json \
  --always-approve
