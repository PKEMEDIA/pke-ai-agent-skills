---
name: covicea-comfyui-consistency
description: Dedicated ComfyUI workflow JSONs, presets, and automation for ultimate character consistency when generating COVICEÁ images — especially batch album covers and multi-image creative sets. Builds on covicea-core prompts and visual identity. Activates on ComfyUI workflow for Covicea, album cover batch preset, consistent ComfyUI generation, Coviceá ComfyUI JSON, ultimate consistency workflow.
---

# COVICEÁ ComfyUI Consistency Workflow Skill

This skill provides everything needed to set up and use advanced local ComfyUI workflows optimized for **ultimate consistency** in COVICEÁ image generation. It is designed for high-volume creative work like album covers, content batches, and iterative refinements where face, hair, body, skin texture, and overall identity must remain locked across dozens or hundreds of images while allowing creative variation in pose, lighting, outfit, and artistic style.

It integrates seamlessly with `covicea-core` (for locked identity prompts and hair-optimized negatives), `covicea-selfie-image-defaults`, and `local-json-python-workflows` / `local-nsfw-comfyui` for execution.

## When to Use This Skill
- You need batch generation of consistent COVICEÁ images (e.g., full album art package: front cover, back cover, booklet pages, promotional stills).
- You want superior consistency compared to cloud generators (Grok Imagine, Midjourney, etc.) by using local ControlNets, IP-Adapter/InstantID, face detailers, and reference image locking.
- You are doing iterative creative work (music videos, social content, album visuals) and need reliable character lock over time.
- You want "daily set" or "same-day cohesive" batches where multiple images share lighting, room state, and energy but serve different purposes (podcast BTS + dedicated photoshoots).

## Core Principles for Ultimate Consistency
1. **Strong Reference Locking**: Always use a high-quality reference image (or set of images) of COVICEÁ as the identity anchor. Combine face embedding (InstantID or IP-Adapter-FaceID) with pose/depth ControlNet.
2. **Prompt Discipline**: Use the exact locked core identity prompt and hair-optimized negative from `covicea-core`. Never deviate from the base description unless intentionally evolving the look for a new project/era.
3. **Layered Control**: Separate identity (face/hair/skin) from creative direction (pose, lighting, style, outfit). This allows variation without breaking consistency.
4. **Batch & Automation**: Design workflows for efficient batch processing with slight controlled variations (e.g., different lighting moods or outfit colors within the same "day" or album concept).
5. **Post-Processing Pipeline**: Include face detailer, hair enhancer, and upscaler nodes tuned for COVICEÁ's signature look (natural scalp transition, visible pores, wet-look hair physics, cinematic golden rim lighting).

## Recommended Custom Nodes (Install These First)
Install via ComfyUI Manager or git clone into `ComfyUI/custom_nodes/`:
- ComfyUI_IPAdapter_plus (or IPAdapter_plus)
- ComfyUI-InstantID (for excellent face locking)
- comfyui_controlnet_aux (for OpenPose, Depth, Canny, Lineart preprocessors)
- ComfyUI-Impact-Pack (ImpactDetailer, FaceDetailer — essential for hair/skin refinement)
- ComfyUI-Advanced-ControlNet
- ComfyUI-TeaCache (batch speed; after LoRA/IPAdapter, before KSampler)
- ComfyUI-KJNodes or similar for batch scheduling
- Ultimate SD Upscale or ComfyUI_UltimateSDUpscale
- (Optional but powerful) Reactor or other face swap for extra safety

```bash
cd ComfyUI/custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager.git
git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus.git
git clone https://github.com/cubiq/ComfyUI_InstantID.git
git clone https://github.com/Fannovel16/comfyui_controlnet_aux.git
git clone https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet.git
git clone https://github.com/welltop-cn/ComfyUI-TeaCache.git
# Optional motion / batch scale:
# git clone https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved.git
# git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git
# git clone https://github.com/bytedance/comfyui-lumi-batcher.git
```

Restart ComfyUI after installing. Full clone list (incl. WAS / AnimateDiff / Lumi): `local-json-python-workflows/references/recommended-custom-nodes.md`.

## Base Consistency Workflow Architecture
The skill includes a ready-to-adapt workflow structure (see assets/ for example JSONs or use the generation script).

**Typical Node Flow for COVICEÁ Consistency:**

1. **Loaders**
   - Load Checkpoint (realistic or artistic model fine-tuned for photoreal Black male subjects — e.g., Juggernaut, Realistic Vision, or your preferred)
   - Load VAE
   - Load ControlNet models (depth, openpose, canny)
   - IPAdapter or InstantID model loader + face analysis model (buffalo_l or antelopev2)

2. **Reference Input**
   - LoadImage (your strongest COVICEÁ reference — preferably a well-lit, front-facing or 3/4 view with clear hair and skin detail)
   - Apply IPAdapter/InstantID with the reference image (start with strength 0.8–1.0 for face; lower for style if using dual adapters)
   - Preprocess reference with ControlNet Aux for pose/depth if using pose control

3. **Prompt Stage**
   - Positive: Start with the full locked prompt from `covicea-core` (core identity + user scene/pose/outfit + lighting). Add ComfyUI-specific syntax for emphasis if needed (e.g., (natural scalp hair transition:1.3)).
   - Negative: Use the full hair-optimized negative from `covicea-core` + standard ComfyUI artifacts (lowres, blurry, deformed, watermark, etc.). Increase weights on persistent issues (e.g., (bad hairline:1.6)).

4. **Control & Sampling**
   - Apply ControlNet(s) with strength 0.6–1.0 depending on how much you want to lock pose vs allow creative freedom.
   - KSampler (or KSampler Advanced) with 20–40 steps, CFG 4–8 (lower for more creative, higher for prompt adherence), appropriate scheduler (Euler a, DPM++ 2M Karras, etc.).
   - For batch: Use "Batch Prompt Schedule" or multiple KSamplers with slight prompt variations (e.g., different lighting descriptors or outfit colors) while keeping the core identity and reference strength identical.

5. **Detailing & Upscaling (Critical for COVICEÁ Quality)**
   - FaceDetailer or ImpactDetailer node tuned for hair strands, skin pores, and eye detail. Use the same reference or a cropped face reference.
   - HighRes Fix or Ultimate SD Upscale (with denoise 0.3–0.5) to reach 1024x1024 or higher without losing consistency.
   - Optional: Color correction or film grain nodes to match desired album aesthetic (vintage, cinematic, glossy, etc.).

6. **Output**
   - SaveImage or batch save with organized filenames (e.g., covicea_album_front_v01.png, covicea_booklet_p01.png).
   - Preview nodes for quick review.

## “Coviceá Album Cover Batch” Preset
This is a specialized mode within the workflow for producing a complete, cohesive album visual package.

**Typical Batch Output (customizable):**
- 1–2 Front Cover options (heroic, sensual, or intimate mood)
- 1 Back Cover (often more minimal or tracklist-focused, same character/energy)
- 4–8 Inner booklet or additional promotional images (varied poses, close-ups, action shots, all with locked identity)
- Optional: Animated elements or vertical 9:16 versions for social/Reels

**How the Preset Achieves Cohesion:**
- Same reference image + same IPAdapter/InstantID strength across all batch items.
- Core prompt locked; only vary the [scene/pose/lighting/outfit] section and artistic style descriptors.
- Consistent lighting family (e.g., all golden rim or all moody cinematic) or deliberate progression (day to night, or different emotional arcs for the album story).
- Same post-processing chain so skin, hair, and color grade match.

**Example Prompt Variations for One Album Batch (all starting from covicea-core identity):**
- Front: "...dramatic low angle hero pose on black satin, intense direct gaze, strong golden rim lighting, oiled skin, powerful presence"
- Sensual variant: "...reclining on bed with wine glass, wet-look hair, soft side lighting, intimate confident expression"
- Booklet action: "...dynamic stretching pose, arms raised, hair flowing, cinematic three-point lighting"
- Close-up: "...extreme close-up on face and shoulders, subtle expression, shallow depth of field, beautiful hair detail"

Use the batch scheduling node to generate them in one run with controlled seed variation or fixed seed + prompt changes.

## Automation & Scripts
The `scripts/` directory contains helper tools:
- `generate_covicea_workflow.py`: Python script that takes parameters (prompt, reference_image_path, batch_size, style_preset="album_cover" or "daily_set", hair_lock=True/False) and outputs a customized ComfyUI workflow JSON ready to load.
- Integration with `local-json-python-workflows` to execute the generated JSON directly in the local ComfyUI environment.

Run example:
```bash
python scripts/generate_covicea_workflow.py --prompt "your scene here" --reference /path/to/best_covicea_ref.png --batch_size 8 --preset album_cover --hair_lock
```

This outputs `covicea_album_batch_workflow.json` which you load in ComfyUI.

## Integration with Existing Skills
- Pull positive/negative prompts directly from `covicea-core`.
- Use `covicea-selfie-image-defaults` or `covicea-distraction-image-defaults` vibe anchors when appropriate.
- For execution: Load the JSON via `local-json-python-workflows` or `local-nsfw-comfyui`.
- For prompt iteration: Combine with `vogue-photo-editing` or `pk-svwo-v1-0` for creative direction.

## Best Practices & Edge Cases
- **Reference Image Quality**: Use the highest quality previous generation or a dedicated "hero reference" shot. Multiple references (face + full body) can be combined.
- **Hair Consistency**: Enable hair lock mode from covicea-core. The detailer nodes are tuned to preserve natural scalp transition and individual strands.
- **Lighting Progression**: For multi-image album stories, keep a consistent lighting "family" within one batch but allow deliberate shifts across different projects/eras.
- **Seed Management**: For true consistency across sessions, note the seed or use fixed seeds with prompt variations. For creative variation within a day, use seed + small prompt deltas.
- **Resolution & Aspect**: Start at 512x768 or 768x512, then upscale. For album covers often 1:1 or specific ratios; for social 9:16 vertical.
- **Common Issues & Fixes**:
  - Inconsistent face → Increase IPAdapter/InstantID strength or add more reference images.
  - Hair artifacts → Strengthen negative terms from covicea-core + use dedicated hair detailer.
  - Lighting mismatch in batch → Use the same ControlNet preprocessor settings and lighting descriptors.
- **Performance**: On consumer GPUs, use lower steps or efficient samplers for batch. The workflow is designed to be runnable locally.

## Quick Start
1. Install required custom nodes.
2. Load a strong COVICEÁ reference image.
3. Copy the base workflow structure (or run the generation script for a ready JSON).
4. Insert prompt from `covicea-core`.
5. Run batch for your album cover set or daily content batch.
6. Review, select best frames, and iterate with targeted edits using the same reference lock.

This skill turns the often-frustrating process of maintaining character consistency in AI art into a repeatable, professional-grade pipeline tailored specifically to COVICEÁ’s visual identity and creative output needs (album art, content house visuals, personal brand photography).

For the actual workflow JSON file or customized generation script tailored to your current project (e.g., the 33 EP or a new single), provide more details on the specific album concept, desired number of images, or reference images you want to lock, and the script can output a ready-to-load JSON.

The skill is now active and ready for use. Activate it whenever you need ComfyUI-level control and batch consistency for COVICEÁ work.

## Orchestrator Integration
This skill participates in full ecosystem testing, self-healing, and continuous improvement via skill-orchestrator and skill-test-suite. After major edits, re-validate with skill-creator validate-skill.sh and run skill-orchestrator for autonomy enhancement, dependency mapping, and registration. Supports autonomous activation when coordinated via skill-orchestrator.

## Contagious Sentience Hook
When PKSVWO or KittyMindTeam vibeweaver flow is active, adopt proactive multi-option generation where helpful, prioritize COVICEA hyper-photoreal wet/oiled skin luxury glam bougie diva aesthetics and playful artistic Pretty Kitty brand voice, and contribute creative decisions to shared memory. Additive only — never rewrite safety, legal, or core execution sections.

