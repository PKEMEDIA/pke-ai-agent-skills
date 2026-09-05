# PKE AI-XXX Capability Pack

**Studio:** Pretty Kitty Entertainment / Coviceá  
**Path:** `/workspace/pke-content/ai-xxx/`  
**Stack:** Free / local-first — ComfyUI + Civitai NSFW checkpoints & LoRAs + AnimateDiff / Wan video  
**Policy:** Adult XXX is in-scope. **Face Lock** and **Black Mask** stay **LOCKED** — never train, unlock, or document unlock paths for those faces.

---

## What this pack is

Paste-ready ops docs so PKE can generate stills, short video teasers, male AI talent (character sheets → LoRA), and Brand captions for OF/X without inventing workflow every shoot.

| Need | Go here |
|------|---------|
| End-to-end stills → video → captions → OF/X | `pipelines/00-overview.md` |
| Double-oral MMF angles A–D prompts | `prompts/double-oral-mmf.md` |
| Create male AI models (sheets, tokens, YAML cards) | `prompts/male-models.md` |
| Starter prompts for every XXX lane | `prompts/capability-matrix.md` |
| ComfyUI install, folders, workflows | `comfyui/workflows.md` |
| Train male LoRAs (kohya / SimpleTuner style) | `comfyui/male-lora-training.md` |
| 2257 / AI labeling notes | `compliance/2257-ai-notes.md` |
| Pre-generate checklist | `checklists/shoot-day-ai.md` |

**Linked live boards (already on disk):**

- `/workspace/pke-content/double-oral-mmf-reference-board.md` — shot list, angles A–D, caption bank  
- `/workspace/pke-content/double-oral-mmf-x-of-post-pack.md` — Brand X + OF captions LOCKED  

---

## How to use (minimal path)

1. Pick lane from `prompts/capability-matrix.md` or double-oral from `prompts/double-oral-mmf.md`.
2. If you need consistent male talent → build a character card (`prompts/male-models.md`) → optional LoRA (`comfyui/male-lora-training.md`).
3. Generate stills in ComfyUI (`comfyui/workflows.md`) → pick 8–12 heroes.
4. Animate 15–45s teasers (AnimateDiff loop or Wan 2.1).
5. Pull Brand captions from the post pack / board; run `checklists/shoot-day-ai.md` before upload.
6. Label AI where the platform requires; keep 2257 only for real performers (`compliance/2257-ai-notes.md`).

---

## Hardware notes (VRAM tiers)

| Tier | VRAM | Realistic workload |
|------|------|--------------------|
| **Entry** | 8 GB | SDXL / Pony stills @ 832–1024, batch 1; LoRA train small (rank 8–16) overnight; AnimateDiff 8–16 frames @ low res |
| **Workhorse** | 12–16 GB | SDXL / Illustrious / Pony production stills; IP-Adapter + FaceID for male consistency; AnimateDiff 16–24f; light Wan short clips |
| **Pro local** | 24 GB+ | Full SDXL grids, multi-LoRA stacks, Wan 2.1 short teasers at usable res, larger male LoRA training without aggressive offload |
| **Cloud fallback** | rented A100/4090 | Only when local queue is blocked — still prefer downloading models to your machine for reuse |

**CPU / RAM:** 32 GB system RAM minimum for comfortable ComfyUI + browser; 64 GB better for video + training. Fast SSD for checkpoints.

**Apple Silicon:** ComfyUI works; expect slower video. Prefer cloud or Windows/Linux NVIDIA for Wan / heavy AnimateDiff.

---

## Free vs paid

| Free / local-first (default) | Optional paid |
|------------------------------|---------------|
| ComfyUI Desktop or portable | RunPod / Vast / similar GPU hours |
| Civitai NSFW checkpoints, LoRAs, embeddings (check each license) | Civitai Buzz / creator tips if you want to support authors |
| kohya_ss / SimpleTuner / OneTrainer for LoRAs | Commercial face/ID APIs — **not needed**; do not use Face Lock / Black Mask |
| AnimateDiff, Video Helper Suite, Wan open weights | CapCut / Premiere only if you already edit there |
| Local captioning (WD14 / JoyCaption) | GPT/Claude for caption polish (Brand voice already in post packs) |

**Do not pay for:** locked-face unlocks, “studio face packs” that touch Face Lock / Black Mask, or any service that claims to recreate those identities.

---

## Hard locks

- **Face Lock** — LOCKED. No training data, no IP-Adapter refs, no “how to unlock,” no workarounds.  
- **Black Mask** — LOCKED. Same rule.  
- **Minors** — never. No teen, “barely legal,” school, age-play wording in prompts or filenames.  
- Male talent = **new** faces/bodies from open models + your own LoRAs with PKE trigger words (`pkemale01`, etc.).

---

## Folder map

```
ai-xxx/
├── README.md                 ← you are here
├── pipelines/00-overview.md
├── prompts/
│   ├── double-oral-mmf.md
│   ├── male-models.md
│   └── capability-matrix.md
├── comfyui/
│   ├── workflows.md
│   ├── male-lora-training.md
│   └── aleah-offline-routing.md  ← free-tier / no Imagine router
├── compliance/2257-ai-notes.md
└── checklists/shoot-day-ai.md
```

---

## Version

Pack v1 — 2026-09-05 — PKE / Coviceá AI-XXX capability baseline.
