#!/usr/bin/env bash
# ci-wall-summary.sh — one-liner wall-time badge from artifacts/ci-timing.json
# Safe to run on Mac or Actions. Prints + writes artifacts/ci-summary.txt
set -euo pipefail
ROOT="${PKE_ROOT:-}"
if [ -z "$ROOT" ]; then
  ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fi
ART="${CONSENSUS_ARTIFACTS:-$ROOT/artifacts}"
mkdir -p "$ART"
python3 - "$ART" <<'PY'
import json, os, sys
from pathlib import Path
from datetime import datetime, timezone

art = Path(sys.argv[1])
timing = {}
tp = art / "ci-timing.json"
if tp.exists():
    try:
        timing = json.loads(tp.read_text())
    except Exception:
        timing = {}

gate = timing.get("gate_ms", "?")
suite = timing.get("suite_ms", "?")
consensus = timing.get("total_ms", "?")
validate = timing.get("validate_ms", "?")
core = timing.get("pipeline_core_ms", "?")
status = timing.get("status", "?")
wall = f"wall: gate={gate}ms suite={suite}ms consensus={consensus}ms validate={validate}ms core={core}ms status={status}"

lines = [
    f"run_id={os.environ.get('GITHUB_RUN_ID', '')}",
    f"sha={os.environ.get('GITHUB_SHA', '')}",
    f"ref={os.environ.get('GITHUB_REF', '')}",
    f"event={os.environ.get('GITHUB_EVENT_NAME', '')}",
    f"timestamp={datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')}",
    "consensus=gate+unit-suite",
    "checkout=actions/checkout@v5",
    f"gate_ms={gate}",
    f"suite_ms={suite}",
    f"consensus_ms={consensus}",
    f"validate_ms={validate}",
    f"pipeline_core_ms={core}",
    f"consensus_status={status}",
    wall,
]
(art / "ci-summary.txt").write_text("\n".join(lines) + "\n")
print(wall)
for line in lines:
    print(line)

summary = os.environ.get("GITHUB_STEP_SUMMARY")
if summary:
    with open(summary, "a") as fh:
        fh.write("### Wall-time one-liner\n\n")
        fh.write(f"`{wall}`\n\n")
        fh.write("| Step | ms |\n| --- | --- |\n")
        fh.write(f"| Gate | {gate} |\n")
        fh.write(f"| Suite | {suite} |\n")
        fh.write(f"| Consensus total | {consensus} |\n")
        fh.write(f"| Parallel validate | {validate} |\n")
        fh.write(f"| Core (consensus+validate) | {core} |\n")
        fh.write(f"| Status | **{status}** |\n")
PY
