#!/usr/bin/env bash
# Submit API-format workflow to Comfy Cloud. Face Lock / Black Mask stay OFF.
# Needs: COMFY_CLOUD_API_KEY (from https://platform.comfy.org/profile/api-keys)
# Paid Comfy Cloud subscription required for /api/prompt.
set -euo pipefail
KEY="${COMFY_CLOUD_API_KEY:?set COMFY_CLOUD_API_KEY}"
BASE="${COMFY_CLOUD_BASE_URL:-https://cloud.comfy.org}"
PAYLOAD="${1:-$(cd "$(dirname "$0")/.." && pwd)/graphs/mixed-double-oral-comfy-cloud.json}"
OUT_DIR="${2:-/workspace/pke-content/ai-xxx/runs/out}"
mkdir -p "$OUT_DIR"

echo "POST $BASE/api/prompt  $(basename "$PAYLOAD")"
RESP="$OUT_DIR/comfy-cloud-prompt-$(date +%Y%m%d-%H%M%S).json"
HTTP=$(curl -sS -o "$RESP" -w '%{http_code}' -X POST "$BASE/api/prompt" \
  -H "X-API-Key: ${KEY}" \
  -H "Content-Type: application/json" \
  --data-binary @"$PAYLOAD")
echo "http=$HTTP saved=$RESP"
python3 - "$RESP" "$HTTP" "$BASE" "$KEY" "$OUT_DIR" <<'PY'
import json, sys, time, urllib.request, pathlib, base64
resp_path, http, base, key, out_dir = pathlib.Path(sys.argv[1]), sys.argv[2], sys.argv[3].rstrip('/'), sys.argv[4], pathlib.Path(sys.argv[5])
data = json.loads(resp_path.read_text() or '{}')
print('body_keys', list(data.keys())[:20])
if http not in ('200', '201'):
    print('submit_failed', data)
    sys.exit(1)
prompt_id = data.get('prompt_id') or data.get('id')
if not prompt_id:
    print('no prompt_id', data)
    sys.exit(1)
print('prompt_id', prompt_id)

def get(url):
    req = urllib.request.Request(url, headers={'X-API-Key': key})
    with urllib.request.urlopen(req, timeout=60) as r:
        return json.loads(r.read().decode())

# Poll jobs endpoint then history fallback
status = None
for i in range(90):
    for path in (f'/api/jobs/{prompt_id}', f'/api/history/{prompt_id}'):
        try:
            status = get(base + path)
            break
        except Exception as e:
            status = {'_err': str(e), '_path': path}
    st = None
    if isinstance(status, dict):
        st = status.get('status') or status.get('state')
        if prompt_id in status and isinstance(status[prompt_id], dict):
            # history shape
            hist = status[prompt_id]
            st = 'completed' if hist.get('outputs') else st
            if hist.get('outputs'):
                status = hist
                break
    print(f'poll {i} status={st}')
    if st in ('completed', 'COMPLETED', 'success', 'SUCCESS') or (isinstance(status, dict) and status.get('outputs')):
        break
    if st in ('failed', 'FAILED', 'error', 'ERROR'):
        print('failed', status)
        sys.exit(2)
    time.sleep(5)
else:
    print('timeout', status)
    sys.exit(3)

(out_dir / f'comfy-cloud-job-{prompt_id}.json').write_text(json.dumps(status, indent=2)[:200000])
# Try to pull images via /api/view if filenames present
outputs = status.get('outputs') or {}
saved = 0
for node_id, node_out in outputs.items():
    for img in (node_out.get('images') or []):
        fn = img.get('filename')
        sub = img.get('subfolder') or ''
        typ = img.get('type') or 'output'
        if not fn:
            continue
        q = f'filename={fn}&subfolder={sub}&type={typ}'
        url = f'{base}/api/view?{q}'
        req = urllib.request.Request(url, headers={'X-API-Key': key})
        try:
            with urllib.request.urlopen(req, timeout=120) as r:
                blob = r.read()
            dest = out_dir / fn
            dest.write_bytes(blob)
            print('wrote', dest, len(blob))
            saved += 1
        except Exception as e:
            print('view_fail', fn, e)
print('images_saved', saved)
PY
