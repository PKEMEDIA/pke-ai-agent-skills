#!/usr/bin/env bash
# Queue mixed double-oral stills against a live ComfyUI API.
# Run ON the machine where ComfyUI listens (studio GPU / registered computer).
# Face Lock + Black Mask stay OFF — never point ckpt/lora at locked assets.
set -euo pipefail
COMFY_URL="${COMFY_URL:-http://127.0.0.1:8188}"
GRAPH="$(cd "$(dirname "$0")/.." && pwd)/graphs/mixed-double-oral-queue.json"
CKPT_OVERRIDE="${1:-}"

if [[ ! -f "$GRAPH" ]]; then
  echo "missing graph: $GRAPH" >&2
  exit 1
fi

if ! curl -sf -m 3 "$COMFY_URL/system_stats" >/dev/null; then
  echo "ComfyUI not reachable at $COMFY_URL" >&2
  echo "Start Comfy first, or set COMFY_URL." >&2
  exit 2
fi

TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT
cp "$GRAPH" "$TMP"

if [[ -n "$CKPT_OVERRIDE" ]]; then
  python3 - "$TMP" "$CKPT_OVERRIDE" <<'PY'
import json, sys
path, ckpt = sys.argv[1], sys.argv[2]
with open(path) as f:
    data = json.load(f)
data["prompt"]["1"]["inputs"]["ckpt_name"] = ckpt
with open(path, "w") as f:
    json.dump(data, f)
print(f"ckpt -> {ckpt}")
PY
fi

# Refuse to queue if placeholder still present
if grep -q 'PLACEHOLDER_NSFW_SDXL' "$TMP"; then
  echo "Replace PLACEHOLDER_NSFW_SDXL.safetensors first:" >&2
  echo "  $0 YourRealNsfwSdxl.safetensors" >&2
  exit 3
fi

echo "POST $COMFY_URL/prompt"
curl -sS "$COMFY_URL/prompt" -H 'Content-Type: application/json' --data-binary @"$TMP"
echo
