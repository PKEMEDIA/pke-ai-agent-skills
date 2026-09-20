#!/usr/bin/env bash
# Submit mixed double-oral (or any) Comfy API workflow to RunPod serverless worker-comfyui.
# Requires: RUNPOD_API_KEY, RUNPOD_ENDPOINT_ID
# Face Lock / Black Mask stay OFF — never load locked assets.
set -euo pipefail
API_KEY="${RUNPOD_API_KEY:?set RUNPOD_API_KEY}"
ENDPOINT_ID="${RUNPOD_ENDPOINT_ID:?set RUNPOD_ENDPOINT_ID}"
PAYLOAD="${1:-$(cd "$(dirname "$0")/.." && pwd)/graphs/mixed-double-oral-runpod.json}"
OUT_DIR="${2:-/workspace/pke-content/ai-xxx/runs/out}"
mkdir -p "$OUT_DIR"

URL="https://api.runpod.ai/v2/${ENDPOINT_ID}/runsync"
echo "POST $URL  payload=$(basename "$PAYLOAD")"
RESP="$OUT_DIR/runpod-response-$(date +%Y%m%d-%H%M%S).json"
curl -sS -X POST "$URL" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  --data-binary @"$PAYLOAD" \
  -o "$RESP"
echo "saved $RESP"

python3 - "$RESP" "$OUT_DIR" <<'PY'
import json, sys, base64, pathlib
resp_path, out_dir = pathlib.Path(sys.argv[1]), pathlib.Path(sys.argv[2])
data = json.loads(resp_path.read_text())
print("status:", data.get("status"), "id:", data.get("id"))
if data.get("error"):
    print("error:", data["error"])
images = (data.get("output") or {}).get("images") or []
if not images:
    print("no images in output; keys:", list((data.get("output") or {}).keys()) or list(data.keys()))
    sys.exit(0 if data.get("status") == "COMPLETED" else 1)
for i, img in enumerate(images):
    name = img.get("filename") or f"out_{i}.png"
    kind = img.get("type")
    payload = img.get("data") or ""
    dest = out_dir / name
    if kind == "s3_url":
        print("s3:", payload)
        (out_dir / f"{name}.url.txt").write_text(payload + "\n")
    else:
        raw = payload
        if raw.startswith("data:"):
            raw = raw.split(",", 1)[-1]
        dest.write_bytes(base64.b64decode(raw))
        print("wrote", dest, dest.stat().st_size, "bytes")
PY
