# Male LoRA Training — PKE (`pkemale##`)

High-level **kohya_ss / SimpleTuner / OneTrainer**-style guide to train **new** male talent LoRAs.  
**Never** include Face Lock or Black Mask images in datasets. Adult faces only (25+ read).

---

## 1. Target

| Item | Recommendation |
|------|----------------|
| Trigger | `pkemale01` (unique, no English word collision) |
| Rank / dim | 8–16 on 8–12 GB; 16–32 on 24 GB |
| Base | Same family you’ll use in prod (SDXL / Pony / Illustrious) |
| Goal | Face + upper body identity; body hung tokens still in prompt |

Train **identity**, prompt **body/cock** — unless you only need clothed marketing (then skip explicit shots).

---

## 2. Dataset size

| Tier | Images | When |
|------|--------|------|
| Minimum | 15–25 | Face-only consistency test |
| Solid | 30–50 | Production face + torso |
| Strong | 50–80 | Multi-angle + a few explicit |

**Variety required:** front, 3/4, profile, eyes-up (critical for double-oral), different lights, slight expression change.  
**Avoid:** 40 near-duplicates of one crop; childlike faces; celebrity lookalikes you don’t have rights to; locked-face material.

Source images = your ComfyUI sheet gens (curated) and/or hired adult model photos you have rights to use for AI training.

---

## 3. Folder layout

```
datasets/
  pkemale01/
    10_pkemale01/           # repeats_prefix_trigger  (kohya style)
      pkemale01_001.png
      pkemale01_001.txt     # caption
      pkemale01_002.png
      pkemale01_002.txt
      ...
    regularization/         # optional class regs (man, adult male)
output/
  pkemale01/
    pkemale01.safetensors
    samples/
```

**Repeats:** `10_pkemale01` means 10 repeats per epoch in classic kohya folder naming — adjust to your trainer. SimpleTuner uses config YAML instead of repeat folders; keep the same caption idea.

Move finished LoRA to `ComfyUI/models/loras/pkemale01.safetensors`.

---

## 4. Captions

**Style:** trigger first, then concrete visible traits. Don’t caption with locked names.

Example `pkemale01_012.txt`:

```
pkemale01, handsome adult Black man, early 30s, deep brown skin, short fade haircut,
short boxed beard, dark brown eyes, looking up at camera, athletic torso, nude,
bedroom lighting
```

Explicit shot example:

```
pkemale01, handsome adult Black man, deep brown skin, short fade, short beard,
standing, large erect penis, trimmed pubes, defined abs, eye contact, studio light
```

**Tips:**

- Drop tags that shouldn’t be locked into the LoRA (e.g. specific room) if you want flexibility.  
- Keep `pkemale01` on **every** caption.  
- For WD14 auto-captions: run auto → manually prepend trigger and delete junk (`child`, `teen`, wrong race tags).

---

## 5. Training steps (high level)

### kohya_ss (concept)

1. Install kohya_ss GUI; select **SDXL** (or your base) LoRA tab.  
2. Point train folder at `datasets/pkemale01`.  
3. Set pretrained model path = **same checkpoint family** as inference.  
4. Network rank 16; alpha 16 (or alpha = rank/2 — stay consistent with your house recipe).  
5. LR ~1e-4 for UNet LoRA (Adafactor / cosine); text encoder LR lower or frozen for face ID.  
6. Resolution 1024 (SDXL); batch 1–2; grad accum as needed.  
7. Epochs: start 10–20 with sample every epoch; stop when face locks without deep-fried skin.  
8. Export safetensors; test at weight 0.6 / 0.75 / 0.9.

### SimpleTuner / OneTrainer (concept)

1. Create dataset config pointing at images + captions.  
2. Choose LoRA/LyCORIS; rank as above.  
3. Enable period sampling with a fixed validation prompt including `pkemale01`.  
4. Save mid-epoch checkpoints; pick the sample that holds likeness without killing prompt flexibility.

**Exact CLI flags change by version** — follow the trainer’s current README; this pack intentionally stays recipe-level so it doesn’t rot.

---

## 6. Naming trigger words

| Good | Bad |
|------|-----|
| `pkemale01` | `john` (collides) |
| `pke_m_ivan` | `man` (too generic) |
| `pkemale01_hung` (style split) | Real celebrity names |
| | `FaceLock`, `BlackMask`, any locked codename |

Document trigger in `prompts/male-models.md` YAML.

---

## 7. Testing grid (before production)

Prompt matrix (same seed set):

| # | Prompt focus | Pass criteria |
|---|--------------|---------------|
| 1 | Face portrait `pkemale01` | Likeness, adult, sharp eyes |
| 2 | Eyes-up between thighs crop | Identity holds looking upward |
| 3 | Full nude body | Body OK; genitals not melted |
| 4 | Double-oral with `pkemale02` | Two **distinct** faces |
| 5 | FemDom kneel | Submissive eyes-up still reads as 01 |
| 6 | Weight sweep 0.5 / 0.75 / 1.0 | Pick default weight |

**Fail →** cut overfit images, add regs, lower rank/epochs, or retake sheet with more angle diversity.

Save grid to `output/pkemale01/samples/grid_YYYYMMDD.png` and mark YAML `train_status: ready`.

---

## 8. Ethics / rights checklist

- [ ] All source adults; rights to train  
- [ ] No Face Lock / Black Mask / stolen locker content  
- [ ] No minors in any form  
- [ ] Trigger documented; LoRA filename matches id  
