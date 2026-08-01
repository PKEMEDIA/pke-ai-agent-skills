#!/usr/bin/env bash
# consensus-gate.sh — shared Raft-lite + HealStampStore readiness (CI + Mac + Super Mind)
#
# Same contract as PKE Skill CI step "Consensus heal gate":
#   1) resolve engine (scripts/ preferred, then skill-orchestrator/)
#   2) node --gate   (lightweight readiness)
#   3) node          (13/13 unit suite + idempotency demos) unless --gate-only
#   4) emit timings  (artifacts/ci-timing.json + optional GITHUB_STEP_SUMMARY)
#
# Usage:
#   bash scripts/consensus-gate.sh                 # gate + suite (CI / Mac deploy default)
#   bash scripts/consensus-gate.sh --gate-only     # heal startup soft path (~40ms)
#   bash scripts/consensus-gate.sh --json          # timings JSON only on stdout (still runs gate)
#   CONSENSUS_SUITE=0 bash scripts/consensus-gate.sh
#
# Env:
#   PKE_ROOT            pack root (auto-detected from script location)
#   CONSENSUS_SUITE     1 (default) | 0  — skip full suite when 0
#   CONSENSUS_STRICT    1 (default for CI) | 0 — non-zero exit on gate fail
#   CONSENSUS_ARTIFACTS override artifacts dir (default: $ROOT/artifacts)
#
# Exit:
#   0  gate (and suite if requested) healthy
#   1  engine missing / gate or suite failed (when strict)
#   2  node missing
set -euo pipefail

GATE_ONLY=0
JSON_OUT=0
for arg in "$@"; do
  case "$arg" in
    --gate-only) GATE_ONLY=1 ;;
    --json) JSON_OUT=1 ;;
    -h|--help)
      sed -n '2,28p' "$0"
      exit 0
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -n "${PKE_ROOT:-}" ] && [ -d "$PKE_ROOT" ]; then
  ROOT="$PKE_ROOT"
elif [ -f "$SCRIPT_DIR/../skill-orchestrator/scripts/consensus-self-heal.mjs" ] \
  || [ -f "$SCRIPT_DIR/consensus-self-heal.mjs" ]; then
  # scripts/ → repo root; skill-orchestrator/scripts/ → repo root via ../..
  if [ -f "$SCRIPT_DIR/consensus-self-heal.mjs" ] && [ "$(basename "$SCRIPT_DIR")" = "scripts" ] \
    && [ -f "$SCRIPT_DIR/../README.md" ]; then
    ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
  elif [ -f "$SCRIPT_DIR/../scripts/consensus-self-heal.mjs" ]; then
    ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
  else
    ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
  fi
elif [ -d "$HOME/PKE/pke-ai-agent-skills" ]; then
  ROOT="$HOME/PKE/pke-ai-agent-skills"
elif [ -d "$HOME/pke-ai-agent-skills" ]; then
  ROOT="$HOME/pke-ai-agent-skills"
else
  ROOT="$(pwd)"
fi

if [ "${CONSENSUS_SUITE:-1}" = "0" ]; then GATE_ONLY=1; fi
STRICT="${CONSENSUS_STRICT:-1}"
ART="${CONSENSUS_ARTIFACTS:-$ROOT/artifacts}"
mkdir -p "$ART"

now_ms() {
  python3 -c 'import time; print(int(time.time() * 1000))' 2>/dev/null \
    || echo $(($(date +%s) * 1000))
}

# Resolve engine: prefer repo scripts/ (Mac paste path), else skill-orchestrator
ENGINE=""
for cand in \
  "$ROOT/scripts/consensus-self-heal.mjs" \
  "$SCRIPT_DIR/consensus-self-heal.mjs" \
  "$ROOT/skill-orchestrator/scripts/consensus-self-heal.mjs"
do
  if [ -f "$cand" ]; then ENGINE="$cand"; break; fi
done

if [ -z "$ENGINE" ]; then
  echo "ERROR: consensus-self-heal.mjs not found under $ROOT" >&2
  exit 1
fi

if ! command -v node >/dev/null 2>&1; then
  echo "ERROR: node not on PATH (required for consensus gate)" >&2
  exit 2
fi

GATE_MS=0
SUITE_MS=0
GATE_OK=0
SUITE_OK=0
SUITE_SKIPPED=0
STATUS="FAIL"

if [ "$JSON_OUT" -eq 0 ]; then
  echo "=== consensus --gate ==="
  echo "engine=$ENGINE"
  echo "root=$ROOT"
fi

t0=$(now_ms)
set +e
GATE_OUT=$(node "$ENGINE" --gate 2>&1)
GATE_RC=$?
set -e
t1=$(now_ms)
GATE_MS=$((t1 - t0))

if [ "$GATE_RC" -eq 0 ]; then
  GATE_OK=1
  if [ "$JSON_OUT" -eq 0 ]; then
    echo "$GATE_OUT"
    echo "gate_ms=${GATE_MS}"
  fi
else
  GATE_OK=0
  if [ "$JSON_OUT" -eq 0 ]; then
    echo "$GATE_OUT" >&2
    echo "gate_ms=${GATE_MS} rc=$GATE_RC" >&2
  fi
fi

if [ "$GATE_ONLY" -eq 1 ]; then
  SUITE_SKIPPED=1
  SUITE_OK=1
else
  if [ "$JSON_OUT" -eq 0 ]; then
    echo "=== consensus unit suite + idempotency demos ==="
  fi
  t2=$(now_ms)
  set +e
  SUITE_OUT=$(node "$ENGINE" 2>&1)
  SUITE_RC=$?
  set -e
  t3=$(now_ms)
  SUITE_MS=$((t3 - t2))
  if [ "$SUITE_RC" -eq 0 ]; then
    SUITE_OK=1
    if [ "$JSON_OUT" -eq 0 ]; then
      echo "$SUITE_OUT"
      echo "suite_ms=${SUITE_MS}"
    fi
  else
    SUITE_OK=0
    if [ "$JSON_OUT" -eq 0 ]; then
      echo "$SUITE_OUT" >&2
      echo "suite_ms=${SUITE_MS} rc=$SUITE_RC" >&2
    fi
  fi
fi

TOTAL_MS=$((GATE_MS + SUITE_MS))
if [ "$GATE_OK" -eq 1 ] && [ "$SUITE_OK" -eq 1 ]; then
  STATUS="HEALTHY"
  if [ "$JSON_OUT" -eq 0 ]; then
    echo "CONSENSUS_ENGINE=HEALTHY"
  fi
else
  STATUS="FAIL"
  if [ "$JSON_OUT" -eq 0 ]; then
    echo "CONSENSUS_ENGINE=FAIL"
  fi
fi

# Write timing artifact (always)
python3 - "$ART/ci-timing.json" "$STATUS" "$GATE_MS" "$SUITE_MS" "$TOTAL_MS" \
  "$GATE_OK" "$SUITE_OK" "$SUITE_SKIPPED" "$ENGINE" <<'PY'
import json, sys, time
from pathlib import Path
path = Path(sys.argv[1])
status, gate_ms, suite_ms, total_ms = sys.argv[2], int(sys.argv[3]), int(sys.argv[4]), int(sys.argv[5])
gate_ok, suite_ok, suite_skipped = int(sys.argv[6]), int(sys.argv[7]), int(sys.argv[8])
engine = sys.argv[9]
data = {
  "stamp": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
  "status": status,
  "gate_ms": gate_ms,
  "suite_ms": suite_ms,
  "total_ms": total_ms,
  "gate_ok": bool(gate_ok),
  "suite_ok": bool(suite_ok),
  "suite_skipped": bool(suite_skipped),
  "engine": engine,
  "mode": "gate-only" if suite_skipped else "gate+suite",
}
path.parent.mkdir(parents=True, exist_ok=True)
# merge prior validate_ms if present
if path.exists():
  try:
    old = json.loads(path.read_text())
    if "validate_ms" in old:
      data["validate_ms"] = old["validate_ms"]
  except Exception:
    pass
path.write_text(json.dumps(data, indent=2) + "\n")
# no stdout here — shell controls --json output
PY

TIMING_JSON=$(cat "$ART/ci-timing.json")

# One-line human summary
LINE="consensus: gate=${GATE_MS}ms suite=${SUITE_MS}ms total=${TOTAL_MS}ms status=${STATUS}"
if [ "$JSON_OUT" -eq 0 ]; then
  echo "$LINE"
fi

# GitHub Actions job summary (when available)
if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
  {
    echo "### Consensus heal gate"
    echo ""
    echo "| Metric | Value |"
    echo "| --- | --- |"
    echo "| Gate | ${GATE_MS} ms |"
    if [ "$SUITE_SKIPPED" -eq 1 ]; then
      echo "| Suite | skipped (gate-only) |"
    else
      echo "| Suite | ${SUITE_MS} ms |"
    fi
    echo "| Total | ${TOTAL_MS} ms |"
    echo "| Status | **${STATUS}** |"
    echo ""
    echo "\`${LINE}\`"
  } >> "$GITHUB_STEP_SUMMARY"
fi

if [ "$JSON_OUT" -eq 1 ]; then
  echo "$TIMING_JSON"
fi

if [ "$STATUS" = "HEALTHY" ]; then
  exit 0
fi
if [ "$STRICT" = "0" ]; then
  exit 0
fi
exit 1
