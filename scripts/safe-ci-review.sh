#!/usr/bin/env bash
set -euo pipefail
export XAI_API_KEY="${XAI_API_KEY:?missing XAI_API_KEY}"
grok --no-auto-update \
  -p "${1:-Review this PR for bugs, security, and style. Be concise.}" \
  --output-format json \
  dontAsk \
  --allow 'Read' \
  --allow 'Grep' \
  --allow 'Bash(git *)' \
  --allow 'Bash(gh *)' \
  --deny 'Bash(rm *)' \
  --deny 'Bash(rm -rf *)' \
  --sandbox strict
