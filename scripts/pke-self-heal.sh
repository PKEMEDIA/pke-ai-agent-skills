#!/usr/bin/env bash
# PKE self-heal - detect gate failures, auto-repair, re-validate, report.
# Usage: bash scripts/pke-self-heal.sh [--push]
# Env:   PKE_ROOT (auto-detected), VALIDATE_SKILL
set -eu

if [ -n "${PKE_ROOT:-}" ]; then
  ROOT="$PKE_ROOT"
elif [ -d /workspace/.grok/skills ]; then
  ROOT=/workspace
elif [ -d /home/workdir/.grok/skills ]; then
  ROOT=/home/workdir
else
  ROOT="$(pwd)"
fi

if [ -z "${VALIDATE_SKILL:-}" ]; then
  for cand in \
    /root/.grok/skills/skill-creator/scripts/validate-skill.sh \
    /root/.grok/server-skills/skill-creator/scripts/validate-skill.sh \
    /home/workdir/.grok/skills/skill-creator/scripts/validate-skill.sh \
    "$ROOT/.grok/skills/skill-creator/scripts/validate-skill.sh"
  do
    if [ -f "$cand" ]; then VALIDATE_SKILL="$cand"; break; fi
  done
fi
VALIDATE="${VALIDATE_SKILL:-}"

LOG_DIR="$ROOT/artifacts/heal-logs"
STAMP=$(date -u +%Y%m%dT%H%M%SZ)
LOG="$LOG_DIR/heal-$STAMP.log"
PUSH=0
if [ "${1:-}" = "--push" ]; then PUSH=1; fi

mkdir -p "$LOG_DIR"

log() { echo "$@" | tee -a "$LOG"; }
log_action() { ACTIONS+=("$1"); log "ACTION: $1"; }

ACTIONS=()
FAILS_BEFORE=0
FAILS_AFTER=0

log "=== PKE SELF-HEAL $STAMP ==="
log "root=$ROOT push=$PUSH validate=${VALIDATE:-MISSING}"

# See full hardened body in skill-orchestrator/scripts or local artifacts.
# This stub bootstraps; full script is mirrored below via orchestrator path.
echo "WARN: incomplete remote copy - use skill-orchestrator/scripts/pke-self-heal.sh"
exit 1
