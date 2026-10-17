# Autonomous Local Production — local-nsfw-comfyui

Adults 21+ only. Consent, 2257, and likeness gates are mandatory (see SKILL.md Hard Gates).

## 1. Portable ComfyUI root resolution
```bash
for c in "${COMFYUI_ROOT:-}" "${PKE_ROOT:+$PKE_ROOT/comfyui}" "$HOME/ComfyUI"; do
  [ -n "$c" ] && [ -f "$c/main.py" ] && { COMFYUI_ROOT="$c"; break; }
done
[ -f "${COMFYUI_ROOT:-/nonexistent}/main.py" ] || { echo "ComfyUI not found; set COMFYUI_ROOT"; exit 1; }
```
Templates live in `$PKE_ROOT/comfyui/workflows/` (or `skills-live/local-nsfw-comfyui/references/` for non-explicit structural examples). Never hard-code user-home or bot-box paths.

## 2. API batch queueing
1. Export the workflow with "Save (API Format)" → `*.api.json`.
2. Validate JSON locally (`python3 -m json.tool file.api.json >/dev/null`).
3. Per job, patch seed / filename_prefix only, then:
```bash
HOST="${COMFYUI_HOST:-127.0.0.1}:${COMFYUI_PORT:-8188}"
curl -s -X POST "http://$HOST/prompt" -H 'Content-Type: application/json' \
  -d "{\"prompt\": $(cat job.api.json), \"client_id\": \"pke-batch\"}"
# → {"prompt_id": "..."}; poll:
curl -s "http://$HOST/history/<prompt_id>"
```
4. Check `/queue` before enqueueing more; keep batch small (1–2) until a test pass is reviewed.
5. Outputs: `$COMFYUI_ROOT/output/<prefix>_*`. Log prompt_id → file in a run manifest (CSV/JSON) for the 2257 record.

## 3. Local machine vs bot cloud box
| Task | Local GPU machine | Bot cloud box |
|------|------------------|---------------|
| Run ComfyUI, models, LoRAs | yes | no (no GPU; no installs) |
| Queue via /prompt | yes (localhost) | no |
| Edit / validate workflow JSON, manifests | yes | yes |
| Reports, skill edits, PRs | — | yes |
Files move between them only via explicit user-approved copy.

## 4. Ship gate
Before export/post: manifest + talent IDs → `pretty-kitty-model-management` (age 21+ verified, consent on file, 2257 records, likeness consent). No pass → no ship. Then `upscayl-workflow-assistant` (finals) → `covicea-brand-assistant` / `pke-ai-xxx` (captions, lanes).
