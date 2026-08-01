#!/bin/bash
# Example test used by automated bisect
# Exit 0 = good, non-zero = bad

STATUS_FILE="/home/workdir/.grok/skills/skill-orchestrator/demo-bisect/status.txt"

if [ ! -f "$STATUS_FILE" ]; then
  echo "Test file missing"
  exit 1
fi

if grep -q "BAD" "$STATUS_FILE"; then
  echo "Test result: BAD (regression present)"
  exit 1
else
  echo "Test result: GOOD"
  exit 0
fi
