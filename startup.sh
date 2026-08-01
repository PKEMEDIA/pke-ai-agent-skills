#!/bin/sh
set -eu
cd "/Users/a1707/PKE/pke-ai-agent-skills"
if curl -sf -o /dev/null --max-time 2 http://127.0.0.1:8080/; then
  exit 0
fi
if [ -f package.json ]; then
  npm run dev >>/tmp/app-startup.log 2>&1 &
fi
