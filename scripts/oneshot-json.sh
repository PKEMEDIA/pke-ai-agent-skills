#!/usr/bin/env bash
set -euo pipefail
export XAI_API_KEY="${XAI_API_KEY:?missing XAI_API_KEY}"
grok --no-auto-update \
  -p "${1:-Explain this codebase in 5 bullets}" \
  --output-format json \
  --always-approve
