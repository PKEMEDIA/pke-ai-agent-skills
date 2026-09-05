# ComfyUI Workflows — PKE AI-XXX (Local-First)

**Stack:** ComfyUI + Civitai NSFW models + AnimateDiff / Wan + FaceID/IP-Adapter for **new** male consistency.  
**Never** load Face Lock / Black Mask refs or train unlock paths.

This doc uses **search terms**, not fake download URLs. On Civitai, search the terms below and pick models with clear commercial/usage terms that fit PKE.

---

## 1. Desktop install (step-by-step)

### Windows / NVIDIA (typical PKE box)

1. Install current **Game-Ready / Studio NVIDIA driver**.  
2. Install **ComfyUI Desktop** (official Electron app) **or** portable: clone `ComfyUI` + python venv + `pip install -r requirements.txt`.  
3. Launch once; confirm the UI opens and the default checkpoint workflow runs.  
4. Install **ComfyUI Manager** (custom node) if not bundled — use it to install nodes below.  
5. Optional: `git pull` + update Manager weekly; pin working node versions before a big shoot week.

### Linux

Same portable path; ensure `pytorch` CUDA build matches driver. Desktop app if available for your distro; else portable.

### Folders (create explicitly)

Relative to ComfyUI root:

```
models/
  checkpoints/     # full NSFW bases (SDXL / Pony / Illustrious-class)
  loras/           # style + pkemale## LoRAs
  embeddings/      # negatives / quality TI if any
  controlnet/      # openpose, depth, canny as needed
  ipadapter/       # IP-Adapter weights
  insightface/     # FaceID / buffalo models if using FaceID nodes
  animatediff/     # motion modules
  vae/             # if not baked in
  diffusion_models/  # Wan / video UNets if your build uses this split
  text_encoders/     # Wan / dual CLIP stacks as required by video nodes
  clip_vision/       # IP-Adapter vision
output/            # gens
input/             # refs, FaceID source sheets (YOUR males only)
```

Map Manager installs into these dirs; don’t scatter LoRAs on the Desktop.

---

## 2. Recommended Civitai model **types** (search terms)

Search Civitai (NSFW login as required). Evaluate previews + license before download.

| Need | Search terms (examples) | Notes |
|------|-------------------------|-------|
| SDXL realistic NSFW base | `SDXL realistic NSFW`, `pornmaster SDXL`, `epicrealism XL` | Prefer SDXL 1.0-compatible |
| Anime / semi / flexible NSFW | `Pony Diffusion`, `Illustrious NSFW`, `NoobAI` | Good LoRA ecosystem; tune prompts to score tags if Pony |
| Explicit detail LoRA | `detail tweaker XL`, `add more details`, `nsfw anatomy` | Keep weight ≤1.0 |
| Skin / melanin | `dark skin LoRA`, `ebony SDXL` | Test so it doesn’t crayon-skin |
| Underwear / lace | `lingerie LoRA`, `lace panties` | Helps “lace aside” |
| Negative embed | `negative XL`, `EasyNegative` (if SD1.5) | SDXL often uses prompt negatives only |
| AnimateDiff | `AnimateDiff SDXL motion`, `animatediff v3` | Match module to base architecture |
| Wan video | `Wan 2.1 ComfyUI`, `Wan2.1 T2V` | Follow current ComfyUI Wan node README for file placement |

**Do not** invent URLs in ops docs. If a model disappears, re-search the term and re-pin the replacement name in `manifest.md` for that shoot.

---

## 3. Stills workflow — node outline

Graph (left → right):

1. **Load Checkpoint** — NSFW SDXL/Pony/Illustrious pick  
2. **Load LoRA** (optional stack) — style LoRA → `pkemale01` → `pkemale02` (two Load LoRA nodes)  
3. **CLIP Text Encode (Positive)** — angle prompt from `prompts/double-oral-mmf.md`  
4. **CLIP Text Encode (Negative)** — shared negative  
5. **Empty Latent Image** — e.g. 832×1216 (portrait) or 1216×832 (landscape stack) or 1024×1024  
6. **KSampler** — Euler a / DPM++ 2M Karras; steps 25–35; CFG 4–7 (Pony often lower CFG)  
7. **VAE Decode**  
8. **Save Image** (+ optional **Image Scale** / Ultimate SD Upscale pass in a second stage)

**Handy optional nodes:**

- **ControlNet OpenPose** — lock two-head side-by-side pose from a stick figure  
- **Inpaint** — hands / lace / tongue fix  
- **FaceDetailer** (Impact Pack) — face fix **after** composition locked  

**Batch:** `batch_size` 2–4 on 12–24 GB; else seed queue manually.

---

## 4. AnimateDiff short loop

1. Start from a working stills graph.  
2. Replace Empty Latent with **AnimateDiff** path:  
   - Load **motion module** compatible with your checkpoint family  
   - Context length 16 (8 GB) or 16–24 (12–24 GB)  
3. Positive prompt: same scene + `subtle motion, licking motion, breathing, eye blink, slow`  
4. Negative: `jitter, morphing face, extra heads, warp`  
5. Sample → **VHS Video Combine** (Video Helper Suite) → mp4/webm  
6. Edit: ping-pong or hold last frame; keep final teaser 15–45s with still cutaways if motion is short.

**Tip:** Animate **tongue ECU** and **eye-contact face stack** as separate 16f clips; cut together in CapCut/Resolve.

---

## 5. Wan 2.1 note

- Treat Wan as the **stronger short-clip** path when VRAM ≥16 GB (24 GB comfortable).  
- Install the ComfyUI Wan / video wrapper nodes via Manager; download **Wan 2.1** weights using the node author’s listed filenames (search: `Wan 2.1 ComfyUI`).  
- Typical use: **text-to-video** or **image-to-video** from a hero still (I2V preferred for character lock).  
- Generate **3–8s** beats matching the reference board shot list; stitch to teaser length.  
- Keep prompts shorter than SDXL essay prompts; emphasize motion verbs: `licking`, `looking up at camera`, `head movement`.  
- If Wan build changes file layout (`diffusion_models` vs old style), follow the **current** node README — don’t fight old tutorials.

---

## 6. FaceID / IP-Adapter for consistent males (NOT Face Lock)

**Goal:** Same `pkemale01` face across stills without locked-face IP.

1. Generate / photograph **your** character sheet (front, 3/4, smile, eyes-up). Save under `input/pkemale01/`.  
2. Install nodes: **IP-Adapter Plus**, **ComfyUI_IPAdapter_plus**, **InstantID** or **FaceID** stack as available for your SDXL pipeline.  
3. Download matching **IP-Adapter** + **CLIP Vision** + **InsightFace** models into the folders above (Manager usually places them).  
4. Wire: sheet image → **IP-Adapter FaceID / Plus Face** → conditioner into KSampler **in parallel** with prompt.  
5. Weight: start ~0.5–0.8 face; lower if anatomy collapses.  
6. For two males: two FaceID chains with two different sheet images (`pkemale01`, `pkemale02`) — or generate separately and composite.  
7. **Forbidden:** any sheet or latent that originates from Face Lock / Black Mask libraries.

After LoRA training (`male-lora-training.md`), you can reduce FaceID weight or drop it for that trigger.

---

## 7. Minimal “shoot night” preset

| Setting | Stills | AnimateDiff | Wan beat |
|---------|--------|-------------|----------|
| Res | 832×1216 | 768×768 or 512×768 | per Wan template |
| Steps | 28 | 20–24 | per template |
| CFG | 5–6 | 5 | lower often |
| Batch | 2–4 | 1 | 1 |

Always write `manifest.md`: checkpoint name, LoRA names/weights, seeds, FaceID on/off.

---

## 8. Troubleshooting

| Symptom | Action |
|---------|--------|
| CUDA OOM | Lower res/batch; `--lowvram` / `--novram`; unload unused models |
| Same face on both males | Separate gens; different LoRAs; lower shared IP weight |
| Soft porn / censored | Stronger NSFW base; remove safety TI; check node isn’t filtering |
| Jitter video | Shorter context; img2vid from sharp still; add more still cutaways |
