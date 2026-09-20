#!/usr/bin/env bash
# AI-XXX pack heal-check wrapper (local, no Imagine / SuperGrok burn)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
exec python3 "$ROOT/scripts/heal-check.py" "$@"
