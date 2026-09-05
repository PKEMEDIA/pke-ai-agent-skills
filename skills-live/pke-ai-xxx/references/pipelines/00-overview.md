# Pipeline Overview — Stills → Video Teasers → Brand Captions → OF/X

**Goal:** One repeatable path from prompt to posted teaser + paid full cut.  
**Primary lane example:** Double Oral MMF (angles A–D).

---

## Linked boards (use these; don’t rewrite captions from scratch)

| Asset | Path |
|-------|------|
| Reference board (angles, shot list, caption bank, hashtags) | `/workspace/pke-content/double-oral-mmf-reference-board.md` |
| Brand X + OF post pack (LOCKED captions) | `/workspace/pke-content/double-oral-mmf-x-of-post-pack.md` |
| Angle prompts (positive/negative A–D) | `/workspace/pke-content/ai-xxx/prompts/double-oral-mmf.md` |
| Male talent system | `/workspace/pke-content/ai-xxx/prompts/male-models.md` |
| Other XXX lanes | `/workspace/pke-content/ai-xxx/prompts/capability-matrix.md` |
| ComfyUI how-to | `/workspace/pke-content/ai-xxx/comfyui/workflows.md` |
| Shoot-day checklist | `/workspace/pke-content/ai-xxx/checklists/shoot-day-ai.md` |

---

## End-to-end stages

### 1. Brief (5–10 min)

- Pick **one** angle per pack: A Shared worship · B FemDom double serve · C Tag-team → toys · D POC amateur.  
- Decide talent: real performer refs (with 2257) **or** AI males via character card / LoRA (`pkemale##`).  
- Output targets:  
  - **X:** 15–45s teaser + Brand caption from post pack  
  - **OF:** longer stills set and/or 60–180s cut + OF caption  
- Note product SKU if angle C (toy bridge / boof cutaway).

### 2. Still generation (ComfyUI)

1. Load NSFW SDXL / Pony / Illustrious-class checkpoint (search Civitai; see `comfyui/workflows.md`).  
2. Paste angle prompt from `prompts/double-oral-mmf.md` (+ male trigger tokens if LoRA’d).  
3. Generate **grid:** 4 seeds × 2 CFG variants × optional 2 LoRA strengths.  
4. Select **8–12 hero stills** covering the board shot list:  
   establishing · face stack · eye-contact · tongue detail · Domme reaction · hands assist · toy bridge (if C) · CTA still.  
5. Upscale winners (4× latent / Ultimate SD Upscale). Fix hands with inpaint if needed.  
6. Export: `pack-id_angle_shot##_v#.png` under a dated folder.

**Quality gates:** eye contact to lens, lace aside readable, both male faces in frame on double-oral, hung/body readable, no locked faces, no minor-coded looks.

### 3. Video teasers

| Path | Use when | Length |
|------|----------|--------|
| **AnimateDiff** short loop | Motion on a hero still / short latent video | 15–24 frames → loop or ping-pong to ~15–30s with hold frames |
| **Wan 2.1** (or current open Wan build) | Stronger motion / camera push | 3–8s clips; stitch 3–5 beats for a 15–45s teaser |
| **Stills slideshow** | GPU weak / deadline | 8 stills × 2–4s Ken Burns + moan SFX bed |

Edit order mirrors the reference board shot list (establishing → eye contact → tongue → reaction → CTA). Burn-in optional soft “Full on OF” only on X cuts if Brand wants it.

### 4. Brand captions

- **Do not freestyle** for this lane when the post pack exists.  
- Copy from `/workspace/pke-content/double-oral-mmf-x-of-post-pack.md`:  
  - X1–X6 for Twitter/X  
  - OF1+ for OnlyFans  
- Match caption angle to the visual angle (A/B/C/D).  
- Hashtags: board search pack (`#doubleoral` `#MMF` `#doublecunnilingus` `#pussyworship` `#femdom` `#tagteam` `#sharedpussy` `#ebonyMMF` `#amateurthreesome` `#POV`).

### 5. Platform export

| Platform | Spec habit |
|----------|------------|
| **X** | Vertical or 1:1 teaser ≤45s preferred; strong first frame = eye-contact still; link/OF CTA in caption |
| **OF** | Full stills set (watermark light) + longer video; tip menu line if toy bridge |
| **IG** (if used) | Softer crop / lace; keep explicit for OF/X |

Filename + sheet: list which files are **AI-generated** vs real talent for internal ops (`compliance/2257-ai-notes.md`).

### 6. QC → upload

Run `/workspace/pke-content/ai-xxx/checklists/shoot-day-ai.md` then schedule/post.

---

## Parallel lanes (same pipeline)

Any row in `prompts/capability-matrix.md` follows the same stages: brief → stills → teaser → captions → QC. Swap prompt file only; keep folder naming and checklist.

---

## Folder naming convention (suggested)

```
/output/pke/YYYY-MM-DD_double-oral_angle-B/
  stills/
  video/
  captions.txt          ← copied Brand lines used
  manifest.md           ← AI vs real, seeds, model names, LoRAs
```

---

## Failure shortcuts

| Problem | Fix |
|---------|-----|
| Hands/anatomy trash | Negatives + inpaint; don’t ship |
| Males look like locked faces | Trash seed; change FaceID ref / LoRA; never use Face Lock / Black Mask assets |
| Teaser too soft for X | Harder first frame, shorter cut, filthy Brand hook |
| Angle C without product clarity | Insert clean hero still of toy before oral resume |
