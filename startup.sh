#!/bin/sh
set -eu
PKE_ROOT="${PKE_ROOT:-$(cd "$(dirname "$0")" && pwd)}"
cd "$PKE_ROOT" || exit 1
if curl -sf -o /dev/null --max-time 2 http://127.0.0.1:8080/; then
  exit 0
fi
if [ -f package.json ]; then
  npm run dev >>/tmp/app-startup.log 2>&1 &
fi
