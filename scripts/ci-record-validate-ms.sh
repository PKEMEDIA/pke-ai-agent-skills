#!/usr/bin/env bash
# Usage: bash scripts/ci-record-validate-ms.sh <validate_ms>
set -euo pipefail
VMS="${1:?validate_ms required}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ART="${CONSENSUS_ARTIFACTS:-$ROOT/artifacts}"
mkdir -p "$ART"
python3 - "$ART/ci-timing.json" "$VMS" <<'PY'
import json, sys
from pathlib import Path
p = Path(sys.argv[1])
vms = int(sys.argv[2])
data = {}
if p.exists():
    try:
        data = json.loads(p.read_text())
    except Exception:
        data = {}
data["validate_ms"] = vms
if "total_ms" in data:
    data["pipeline_core_ms"] = int(data.get("total_ms") or 0) + vms
p.write_text(json.dumps(data, indent=2) + "\n")
print(f"validate_ms={vms}")
if "pipeline_core_ms" in data:
    print(f"pipeline_core_ms={data['pipeline_core_ms']}")
PY
if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
  {
    echo "### Parallel skill validate"
    echo ""
    echo "| Metric | Value |"
    echo "| --- | --- |"
    echo "| Validate | ${VMS} ms |"
    echo ""
  } >> "$GITHUB_STEP_SUMMARY"
fi
