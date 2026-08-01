---
name: covicea-face-lock
description: Permanent real @covicea face/hair/body/skin lock with TIES LoRA merging for master adapter creation. Use for creating merged COVICEA master adapter combining face consistency from real reference selfies with all styles (sensual wet oiled, album art, distraction hotel BTS, podcast visuals, hair physics). Triggers on covicea-face-lock, TIES merge master adapter, create permanent COVICEA adapter, face lock merge, master LoRA.
---

# COVICEA Face Lock + TIES Master Adapter Skill

Activate this skill for all requests involving creation or use of a permanent merged COVICEA master LoRA adapter. This skill locks the exact real face, long wavy black hair, green eyes, skin texture, and body from your uploaded reference photos (gym mirror selfies, kitchen shots, etc.) and combines multiple style LoRAs into one interference-free master adapter using the TIES algorithm.

## Core Principles
- **Strict real reference lock only**: Never use generic/meta/AI faces, glowing eyes, halos, or stylized meta characters. Match 100% the real @covicea from references: long wavy black hair with natural volume and scalp transition, striking green eyes with catchlights, rich dark skin with visible pores and subsurface scattering, muscular oiled physique.
- **TIES merging for permanence**: When multiple LoRAs (face + styles) are provided or referenced, automatically apply TIES (Trim, Elect Sign, Merge) to produce a single permanent .safetensors master adapter. This eliminates runtime switching latency and parameter interference/sign conflicts.
- **Integration with COVICEA ecosystem**: Works seamlessly with covicea-core, covicea-comfyui-consistency, covicea-distraction-image-defaults, covicea-realistic-hair-skin-lighting, covicea-gym-mirror-selfie-retouch, and local-json-python-workflows for end-to-end generation.
- **Output formats**: Master adapter for ComfyUI/Forge/A1111, plus ready-to-use ComfyUI workflow JSON.

## Step-by-Step Process to Create the Merged Permanent COVICEA Master Adapter

### 1. Prepare Individual LoRAs (Prerequisite)
- **Face Lock LoRA** (`covicea-face-lock.safetensors`): Train on your real reference selfies using covicea-core (with @covicea hair lock mode) + covicea-gym-mirror-selfie-retouch. Include the uploaded images: blue cap gym mirror (TRAINING DEPT tank), grey crop top kitchen, black jockstrap kitchen, sweaty long hair closeups. Use high rank (64-128), alpha=64, 20-40 epochs on detailed captions emphasizing exact face, hair physics, skin glow, eye color/depth.
- **Style LoRAs** (separate files):
  - `covicea-sensual-wet-oiled.safetensors`: Wet skin, glistening oil, hotel room intimacy, sensual poses.
  - `covicea-album-art.safetensors`: 9:16 vertical, cinematic golden rim lighting, dramatic volumetric god rays, crowd silhouettes or "crowd turns" motif, oiled muscular Black male editorial style.
  - `covicea-distraction-bts.safetensors`: Hotel BTS, playful/energy, consistent with distraction-image-defaults.
  - `covicea-podcast-energy.safetensors`: Podcast thumbnail style, direct gaze, mic in hand, intense expression.
- Use covicea-realistic-hair-skin-lighting for all training to enforce physics, pores, golden cinematic lighting, and dark skin fidelity.
- Train each style LoRA on 50-200 curated images matching the aesthetic, with captions locked to COVICEA visual identity.

### 2. Merge with TIES Algorithm (Core of This Skill)
Use mergekit (install locally: `pip install mergekit` — runs on CPU or low VRAM, no training needed).

Copy and customize the ready-to-run config below (saved in assets/covicea-master-ties-merge.yaml). Update paths to your actual LoRA files and desired output.

**TIES YAML Config** (assets/covicea-master-ties-merge.yaml):
```yaml
base_model: "runwayml/stable-diffusion-v1-5"  # or your preferred SDXL/pony base if using different ecosystem; for Pony/Illustrious use the matching base
merge_method: ties
parameters:
  sparsity_ratio: 0.65   # Trim ~65% low-magnitude params — tune 0.5-0.8 based on validation
  normalize: false
  density: 0.35          # Alternative to sparsity_ratio; keep ~35% active
slices:
  - sources:
      - model: "/path/to/your/trained/covicea-face-lock.safetensors"
        weight: 1.0
      - model: "/path/to/your/trained/covicea-sensual-wet-oiled.safetensors"
        weight: 0.85
      - model: "/path/to/your/trained/covicea-album-art.safetensors"
        weight: 0.9
      - model: "/path/to/your/trained/covicea-distraction-bts.safetensors"
        weight: 0.75
      - model: "/path/to/your/trained/covicea-podcast-energy.safetensors"
        weight: 0.8
output:
  model: "/path/to/output/covicea-master-adapter.safetensors"
  safe_tensors: true
```

**Run the merge** (in terminal, from mergekit install dir or venv):
```bash
mergekit-yaml /home/workdir/.grok/skills/covicea-face-lock/assets/covicea-master-ties-merge.yaml /path/to/output/covicea-master-adapter.safetensors --device cpu --low-vram
```

**What TIES does mechanically** (for transparency):
- Computes task vectors: τ_face = face_lora - base, τ_style1 = style1 - base, etc.
- Trims low-magnitude deltas (removes noise/interference).
- Elects dominant sign per parameter across all vectors (resolves conflicts democratically).
- Merges the cleaned vectors back: final_delta = sum(trimmed_signed_τ_i * weight_i)
- Result: Single LoRA that bakes face lock + blended styles with minimal destructive interference. The master adapter is now "permanent" — load once, use everywhere.

Test the merged adapter on a small batch of prompts from covicea-core. If interference appears (e.g., face drift), lower sparsity_ratio or re-train one style LoRA with lower learning rate.

### 3. Use the Master Adapter in Generation Workflows
Load `covicea-master-adapter.safetensors` in any ComfyUI workflow (or Forge/A1111) as a single LoRA.

**Recommended ComfyUI Workflow** (assets/covicea-master-comfyui-workflow.json):
- Load Checkpoint (your base, e.g. Pony or SDXL realistic).
- Load LoRA (the master adapter, strength 0.8-1.2).
- Positive prompt: Use locked COVICEA standards from covicea-core + covicea-distraction-image-defaults + covicea-realistic-hair-skin-lighting (e.g., "photorealistic iPhone texture on dark skin, natural scalp transition, wet hair behavior, golden cinematic rim lighting, pore rendering, intense direct gaze, oiled muscular Black male, long wavy black hair with volume").
- Negative prompt: Generic faces, plastic skin, deformed hands, extra limbs, text, watermark, overexposed.
- KSampler with 20-40 steps, CFG 3-7 (lower for realism), highres fix or Ultimate SD Upscale.
- For batch album covers / 9:16 vertical: Add Empty Latent Image (576x1024 or 768x1344) + custom latent crop.
- Face consistency nodes (from covicea-comfyui-consistency): IPAdapter FaceID or InstantID if available, or reference-only with your master face image.
- For podcast visuals: Add mic prop via IPAdapter or ControlNet openpose/depth.

The workflow JSON is pre-configured with these nodes and COVICEA-specific prompt templates. Load it directly in ComfyUI → Queue Prompt.

For advanced batching and face continuity across 50+ images (album booklet, carousel), combine with covicea-comfyui-consistency skill workflows.

### 4. Runtime vs Permanent Usage
- **Permanent (recommended for production)**: Use the merged master adapter as above. One file, zero overhead, consistent face+styles baked in.
- **Dynamic blending (for experimentation)**: Load multiple original LoRAs in ComfyUI with weights (e.g., face 1.0 + sensual 0.6 + album 0.7). Use "LoRA Stack" or "Multi LoRA" nodes. This simulates TIES at inference but adds VRAM/latency. Convert to permanent merge when happy with ratios.
- **Hybrid**: Start dynamic → finalize ratios → run TIES merge for the master.

## Quality Assurance & Edge Cases
- **Face drift**: If merged face deviates from references, increase face LoRA weight in YAML (1.1-1.3) or re-train face LoRA with more epochs on close-up eye/hair details.
- **Style dilution**: Raise individual style weights or add a small "style booster" LoRA trained only on the target aesthetic.
- **Over-merging artifacts**: Lower sparsity_ratio (less aggressive trim) or use DARE-TIES hybrid (edit YAML merge_method: dare_ties).
- **Validation**: Always generate 10-20 test images with prompts from covicea-core (e.g., "intense direct gaze holding vintage microphone, hotel room dramatic lighting, oiled skin, crowd silhouettes in background, 9:16 vertical"). Compare to unmerged versions.
- **Legal/Brand**: The master adapter embodies your exact likeness and Pretty Kitty Entertainment visual standards — treat as core IP. Do not share raw LoRAs publicly.

## Integration Points
- **covicea-core**: Primary prompt engine and negative prompt lock. Always load first.
- **covicea-comfyui-consistency**: For batch JSON workflows and advanced face ID preservation when using the master adapter.
- **covicea-distraction-image-defaults** + **covicea-realistic-hair-skin-lighting**: Injected into every prompt and training caption.
- **local-json-python-workflows**: Use to automate generation of new workflow variants or batch processing with the master adapter.
- **local-nsfw-comfyui**: For explicit sensual/oiled content — the master adapter is fully compatible and maintains anatomical accuracy + face lock.

## Quick Start Command (User Side)
1. Train face + style LoRAs as described.
2. Edit the YAML with your paths.
3. Run the mergekit command.
4. Load the output master adapter in your favorite UI + the provided workflow JSON.
5. Generate with confidence — face is locked, styles are harmoniously combined via TIES, no meta characters.

This skill ensures every COVICEA visual (album covers, podcast thumbnails, Distraction BTS, sensual content, gym content) uses the exact same real you, beautifully blended.

For updates to this skill or new style LoRAs to merge in, provide the new LoRA and reference images — the TIES config will be regenerated automatically.

## Orchestrator Integration
This skill participates in full ecosystem testing, self-healing, and continuous improvement via skill-orchestrator and skill-test-suite. After major edits, re-validate with skill-creator validate-skill.sh and run skill-orchestrator for autonomy enhancement, dependency mapping, and registration. Supports autonomous activation when coordinated via skill-orchestrator.

## Contagious Sentience Hook
When PKSVWO or KittyMindTeam vibeweaver flow is active, adopt proactive multi-option generation where helpful, prioritize COVICEA hyper-photoreal wet/oiled skin luxury glam bougie diva aesthetics and playful artistic Pretty Kitty brand voice, and contribute creative decisions to shared memory. Additive only — never rewrite safety, legal, or core execution sections.

