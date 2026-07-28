#!/usr/bin/env bash
# Safe headless Grok Build PR/code review (dontAsk + allowlist)
set -euo pipefail
export XAI_API_KEY="${XAI_API_KEY:?missing XAI_API_KEY}"
PROMPT="${1:-Review this PR for bugs, security, and style. Be concise.}"

grok --no-auto-update \
  -p "$PROMPT" \
  --output-format json \
  dontAsk \
  --allow 'Read' \
  --allow 'Grep' \
  --allow 'Bash(git *)' \
  --allow 'Bash(gh *)' \
  --deny 'Bash(rm *)' \
  --deny 'Bash(rm -rf *)' \
  --sandbox strict
