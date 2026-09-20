# Fix: No GPU / ComfyUI on Grok Bot computer

## Diagnosis (2026-09-06)

| Check | Result |
| --- | --- |
| NVIDIA devices (`/dev/nvidia*`) | **none** |
| `nvidia-smi` | not installed |
| GPU / DRI | none |
| CPU | Intel Xeon, 8 vCPU |
| RAM | 15 GiB, usually near full (Chrome renderers) |
| ComfyUI on box `localhost:8188` | **not running** |
| Registered user machines | **none** |

Grok Bot’s computer is a **CPU-only** cloud VM. You cannot install a GPU that is not in the hardware. Installing ComfyUI+PyTorch on CPU here would OOM or take hours per SDXL still and is **not** the PKE L0 path.

## Real fix (Aleah L0)

1. Keep ComfyUI running on your **studio GPU machine** (`http://127.0.0.1:8188`).
2. Register that machine in Grok Bot → [Computers](grokbot://app/v1/settings?id=computers).
3. Tell Creator (or Orchestrator) it’s linked. We then run Shell **on your machine** and `POST` the queue JSON to `localhost:8188`.
4. Before first queue: put a real NSFW SDXL checkpoint in Comfy `models/checkpoints/` and pass its filename to the queue script (never Face Lock / Black Mask packs).

```bash
# On the registered GPU machine (after graph + ckpt are present):
bash /path/to/ai-xxx/comfyui/scripts/queue-mixed-double-oral.sh YourNsfwSdxl.safetensors
```

Or from Creator once the machine is registered: same `curl` / script via `machineId`.

## Not a fix

- Installing ComfyUI on the Grok Bot box without a GPU
- Grok Imagine for pack stills (Aleah LX — forbidden for pack ops)
- Pointing workflows at Face Lock / Black Mask assets

## Optional L2 (spend)

Only if L0 studio GPU is down and Coviceá approves: rent RunPod/Vast GPU, download weights home, reuse locally. See `aleah-offline-routing.md`.

## L2 path — PKEMEDIA/worker-comfyui (serverless)

Repo: https://github.com/PKEMEDIA/worker-comfyui  
(ComfyUI as RunPod serverless API — `/run` + `/runsync`)

### Deploy once (RunPod console)

1. Serverless → New Endpoint → use image `runpod/worker-comfyui:<ver>-sdxl` (or custom NSFW image / network volume).
2. GPU: ≥8 GB for SDXL; 24 GB class for heavier NSFW stacks.
3. Copy **Endpoint ID**. Create **API Key** under User Settings.
4. For true NSFW: bake a Civitai NSFW SDXL into a custom image (see repo `docs/customization.md`) or attach a network volume with `models/checkpoints/<nsfw>.safetensors` and set `ckpt_name` in the workflow to that filename. Stock `sdxl` image is SFW base — expect soft results until NSFW weights are mounted.
5. Never point models at Face Lock / Black Mask packs.

### Submit this shoot

```bash
export RUNPOD_API_KEY=...
export RUNPOD_ENDPOINT_ID=...
# edit graphs/mixed-double-oral-runpod.json ckpt_name to match mounted weights
bash comfyui/scripts/runpod-runsync.sh
# heroes land in ai-xxx/runs/out/
```

Payload: `graphs/mixed-double-oral-runpod.json` (API workflow wrapped for `/runsync`).

## L2 alt — Comfy Cloud API (cloud.comfy.org)

Browser GitHub login on the Grok Bot desktop hit “Network error” (2026-09-06). Prefer API key path:

1. Create key at https://platform.comfy.org/profile/api-keys  
2. Paid Comfy Cloud plan required for `/api/prompt` (free tier UI-only).  
3. Export `COMFY_CLOUD_API_KEY`, then:

```bash
# ckpt_name in the JSON must exist on Comfy Cloud’s model library
bash comfyui/scripts/comfy-cloud-run.sh
```

Payload: `graphs/mixed-double-oral-comfy-cloud.json`  
Auth header: `X-API-Key` · Base: `https://cloud.comfy.org`  
Face Lock / Black Mask stay OFF. Replace `PLACEHOLDER_NSFW_SDXL.safetensors` with a Cloud-available NSFW/realistic checkpoint name before expecting explicit results.
