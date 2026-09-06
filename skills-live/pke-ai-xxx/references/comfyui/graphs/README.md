# Comfy API graphs

| File | Role |
|------|------|
| `stills-grid.json` | Hero stills API workflow (SDXL/Pony-class + optional LoRA stack) |
| `animatediff-teaser.json` | Short AnimateDiff loop → VHS mp4 (needs ADE + Video Helper Suite) |
| `*.meta.json` | Defaults / notes (not loaded by Comfy) |
| `validate-graphs.py` | Offline structure check — **no GPU, no Imagine** |

## Use

1. Put NSFW checkpoint + optional `pkemale##` LoRAs in Comfy `models/` folders.
2. Edit JSON: replace every `PLACEHOLDER_*.safetensors` with real filenames.
3. ComfyUI → **Load** (or API `/prompt`) the JSON.
4. Offline check: `python3 validate-graphs.py`

**Status:** `template-api` — structurally valid for sim; re-export from a live GPU run when Comfy is up and overwrite these files as `status: gpu-validated`.

**Locks:** Never point ckpt/lora/input sheets at Face Lock or Black Mask assets.
