---
name: local-nsfw-comfyui
description: Automatically manages all local ComfyUI workflows for unrestricted photorealistic explicit adult NSFW images and video. Prioritizes anatomical accuracy, character consistency, and full creative control without any cloud moderation. Activates automatically for any NSFW generation, explicit content, ComfyUI pipelines, anatomy work, or local uncensored production requests.
---

# Local NSFW ComfyUI Workflows

Use this skill when the user needs to set up or build ComfyUI pipelines for explicit adult content that cloud tools block. Focus on photorealistic real-people results, precise anatomy, and reusable production workflows for gay male / interracial / fetish scenes.

## Hardware & Installation
Install on a machine with NVIDIA GPU. Minimum 12 GB VRAM is viable with modern optimizations; 16–24 GB recommended for comfortable Flux/SD3.5 + heavy IP-Adapter + LoRA stacks in high-resolution explicit work. Use the Windows portable version or standard Git install. Always install ComfyUI-Manager first for easy custom node installation (ControlNet, IP-Adapter, ADetailer, Ultimate SD Upscale, AnimateDiff, and memory-related nodes like Crystools or VRAM Debug).

## Memory Optimization & Dynamic VRAM (2026 Best Practices)
Dynamic VRAM (powered by the AI Model Dynamic Offloader / aimdo) is the major 2026 memory system in ComfyUI. It uses virtual address mapping and on-demand weight loading, dramatically lowering system RAM pressure while enabling larger models and more complex explicit workflows (multiple IP-Adapter FaceID references, heavy anatomy LoRA stacks, high-res batches) on 12–24 GB GPUs with far fewer OOMs.

**Launch flags & configuration:**
- Usually enabled by default on NVIDIA Windows/Linux in recent versions — check startup logs for “aimdo: DynamicVRAM support detected and enabled”.
- Force control: Add `--enable-dynamic-vram` to your launch command, or `--disable-dynamic-vram` to test legacy behavior.
- Recommended companion flag: `--fast-disk` (especially on NVMe SSDs for quicker model/LoRA swapping).
- Traditional flags like `--lowvram` or `--highvram` have reduced impact when Dynamic VRAM is active.

**Workflow recommendations for gay male / explicit content:**
- Prefer fp8_e4m3fn or GGUF-quantized UNETs for Flux and SD3.5 families.
- Use separate UNETLoader + DualCLIPLoader / TripleCLIPLoader instead of single CheckpointLoader for modern models.
- Dynamic VRAM excels with IP-Adapter FaceID stacks + multiple targeted LoRAs (muscular definition, genital detail, skin texture, sweat) — it gracefully manages the combined memory load.
- Pair with ADetailer / Impact detailers and ControlNet (OpenPose + Depth) for anatomy-critical explicit poses without excessive VRAM spikes.
- Monitor runtime usage with Crystools resource nodes or dedicated VRAM Debug nodes.
- For maximum throughput on mid-range hardware: Dynamic VRAM + quantization + TeaCache (if available) + moderate batch sizes (start with 1–2 and scale up).

This system makes reliable local production of high-detail explicit carousels, character-consistent series, and short motion clips far more practical without constant hardware strain or workflow compromises.

## TeaCache Integration for Speed
Install the **ComfyUI-TeaCache** custom node pack via ComfyUI-Manager. It caches intermediate computations (especially useful in repetitive or batch workflows with consistent elements like character poses, lighting, or anatomy).

**Placement in workflows:**
- Add the TeaCache node **after model loading and all LoRA/IP-Adapter applications**, but **before the KSampler / SamplerCustomAdvanced**.
- For AnimateDiff video: Place after motion module application as well.
- Enable caching for the diffusion model path. Experiment with cache size/strategy for your explicit scenes (e.g., higher cache for fixed camera angles in carousels).

**Benefits for your production:**
- Noticeable speedup on still carousels with shared elements (same two models, similar poses, consistent lighting/sweat/skin details).
- Combines powerfully with Dynamic VRAM and quantization for higher throughput without quality loss.
- Test with small batches first, then scale. Monitor for any minor quality variations in edge cases (rare with good settings).

Update your reusable .json templates to include TeaCache nodes where appropriate for faster iteration on explicit content.

## Core Models & Sources
Start with Juggernaut XL v9 or v10 for strong photorealism and anatomy on SDXL. Move to Flux.1 dev fine-tunes or CHROMA/uncensored Flux merges for superior prompt adherence and realistic proportions. Download base checkpoints from Hugging Face or Civitai. Source all LoRAs and specialized checkpoints from Civitai using tags: muscular male, gay, nsfw, realistic, detailed anatomy, interracial, sweat, skin texture. Build character consistency with dedicated LoRAs for specific body types, hair (dreads, curly), skin tone, and genital detail.

## Building Production Explicit Workflows
Always begin with Load Checkpoint (Juggernaut or Flux). Add multiple LoRA Loader nodes for anatomy fixes, muscular definition, character consistency, and explicit detail. Connect CLIP Text Encode for positive prompt (detailed real-photograph language, exact models, pose, lighting, fluids) and negative prompt (deformed anatomy, extra limbs, blurry, lowres, censored). Use Empty Latent Image for target resolution and batch size. Core generation happens in KSampler or SamplerCustomAdvanced — tune steps, CFG, sampler, and scheduler per model. Decode with VAE Decode then route to Save Image or batch output nodes.

For reverse cowgirl or complex explicit poses, insert ControlNet Apply nodes (OpenPose or Depth) with a reference pose image to lock rider position, penetration angle, and body contact. Add IP-Adapter or FaceID nodes with reference photos of the two models to keep the white dreads bottom and light-skin mixed Black rider consistent across an entire carousel. Insert ADetailer or custom detailer nodes after sampling to auto-correct faces, hands, and genital anatomy in close-ups.

## Prompting for Real-People Photoreal Explicit
Write positive prompts as if directing a real photo shoot: “photorealistic live-action photograph of two actual athletic adult men in their mid-20s, [precise description of white dreads bottom and mixed Black rider], reverse cowgirl position, deep anal penetration, intense prostate orgasm, visible fluids, glistening sweat and natural skin texture, shot on Canon EOS R5, 85mm lens, shallow depth of field, 8k”. Use strong negative prompts focused on anatomy failures. Add style tokens like “real photograph, no AI artifacts, natural imperfections, film grain” to push away plastic AI look. For fluids and fetish elements, be direct in the prompt once the base anatomy is solid.

## Carousel & Variation Generation
Build one master workflow, then duplicate the sampler or latent nodes with different seeds or slight prompt variations for 4–6 images in a single run. Use batch nodes and VHS or image sequence output for easy carousel assembly. Apply consistent ControlNet pose across all variations so the reverse cowgirl framing and body relationship stays identical while changing camera angle or intensity.

## Video Extension – AnimateDiff for Explicit Motion
For short explicit video clips (reverse cowgirl thrusting, anal orgasm, fluids), extend the image workflow with AnimateDiff-Evolved nodes. This is currently the most practical local path for leveraging your existing Juggernaut/Flux models + LoRAs while adding motion.

**Specific node recommendations (ComfyUI-AnimateDiff-Evolved pack):**
- AnimateDiff Loader (motion module: stabilized or v3/v4 recommended for human motion).
- AnimateDiff Apply or Evolved Sampling nodes for the core animation loop.
- ControlNet Apply (OpenPose) – primary for locking rider squat, leg position, hip angle, and penetration.
- ControlNet Apply (Depth) – secondary for consistent body overlap and penetration depth during motion.
- IP-Adapter (FaceID or Plus) – one node per character or batched; reference clean face + body images of the white dreads bottom and light-skin mixed Black rider to maintain identity across frames.
- ADetailer or custom detailer nodes on output sequence for face, hands, and genital fixes in motion.
- Batch or VHS nodes for outputting image sequences (easier to edit than direct video).

**Starter workflow description for reverse cowgirl motion (image-to-video recommended):**
1. Generate or load your best still reference image of the exact scene (two athletic 21+ men, white with dreads as bottom, mixed Black as rider in reverse cowgirl, deep penetration, intense expressions).
2. Preprocess reference: OpenPose estimator → pose skeleton map. Depth estimator → depth map.
3. Main pipeline: Load Checkpoint (Juggernaut XL or realistic Flux) + multiple LoRA Loaders (muscular male, anatomy detail, skin texture, sweat, explicit genital, character-specific if available).
4. Positive prompt: “photorealistic live-action photograph of two actual athletic adult men in their mid-20s, white male with long dreadlocks as bottom lying supine, light-skin mixed Black male as rider squatting reverse cowgirl, deep anal penetration, rider experiencing powerful prostate/anal orgasm with his thick erect cock leaking visible stream of clear piss from the urethra onto bottom’s abs, glistening sweat, intense ecstatic expressions, natural skin pores and textures, shot on Canon EOS R5, 85mm lens, shallow depth of field”.
5. Strong negative prompt focused on anatomy, deformation, and blur.

## Minimizing iOS On-Device Sensitive Content Detection

To reduce the chance of iOS Photos app flagging generated explicit content:

- Generate and save locally (never upload to cloud services).
- Use the Python metadata stripping script from `local-json-python-workflows`.
- Save final images/videos to the **Files app** instead of Photos when possible.
- Consider slight post-processing (light blur on edges or minor color grading) if flagging occurs frequently.
- Use third-party gallery/viewer apps that have weaker or disabled sensitive content detection.
- For videos: Render with ffmpeg using clean encoding settings and stripped metadata.
6. Empty Latent Image (e.g. 1024x1536 or landscape for action).
7. Wire KSampler/SamplerCustomAdvanced with AnimateDiff motion module active.
8. Insert ControlNet Apply (OpenPose) using preprocessed pose map, strength 0.9–1.1.
9. Insert ControlNet Apply (Depth) using preprocessed depth map, strength 0.7–1.0.
10. Insert IP-Adapter nodes with your two character reference images (strength 0.7–0.9) to lock identity.
11. After sampling: VAE Decode → ADetailer (face + hands + genital pass) → Save Image / batch sequence output.
12. For video: Feed the image sequence into ffmpeg (or CapCut) for final timing, color grade, and any slow-motion on the orgasm/piss moment.

**Exact settings that work well for realistic gay male explicit animation:**
- Motion module context: 16–24 frames for short thrusting/orgasm clips.
- ControlNet strengths: OpenPose 1.0, Depth 0.8 (adjust down if motion feels robotic).
- CFG: 5–7 (slightly lower than stills for smoother motion).
- Steps: 25–40.
- Sampler/Scheduler: Euler a or DPM++ 2M Karras with AnimateDiff-compatible settings.
- IP-Adapter strength: 0.75–0.85 per character to balance identity lock vs natural expression change during orgasm.
- Start with image-to-video from your best still rather than pure text-to-video for superior anatomy and composition control.
- For the piss leak during anal orgasm: Keep it in the prompt once base anatomy is solid; the combination of strong ControlNet pose lock + good anatomy LoRAs produces the cleanest fluid motion.

Test small batches, inspect for anatomy drift in thrusting frames, then lock the workflow as a reusable .json. This stack gives you full local control over the exact explicit carousel and short video clips you originally requested, with no cloud moderation.

**Integration Note (July 2026)**: For maximum character consistency with the locked male model, load the master adapter produced by the DARE-TIES merge from the spicy-male-erotic-prompt-optimizer skill (face + sensual style LoRAs). Combine with IP-Adapter FaceID (strength 0.75–0.85) using the original reference image (IMG_3360.jpg) for the strongest identity lock across stills and motion. See the Complete Production Pipeline Summary in spicy-male-erotic-prompt-optimizer for the full recommended workflow.

## Anatomy & Quality Fixes
Common explicit-scene problems (hands, genitals, anus, penetration) are solved with targeted LoRAs + ADetailer + higher step counts + ControlNet. Test small batches, inspect, then iterate the workflow. Save every working version as a named .json so you can reload and adapt for new scenes instantly.

## Professional Production Notes
Treat this like any other adult content tool: maintain character consistency for brand, generate test shots before full shoots, and keep final human review on all explicit output. Local gives complete freedom and privacy but places full responsibility on you for age accuracy, consent, and distribution legality. This setup replaces every moderated cloud generator for high-volume explicit work.

## Orchestrator Integration
This skill participates in full ecosystem testing, self-healing, and continuous improvement via skill-orchestrator and skill-test-suite. After major edits, re-validate with skill-creator validate-skill.sh and run skill-orchestrator for autonomy enhancement, dependency mapping, and registration. Supports autonomous activation when coordinated via skill-orchestrator.

## Contagious Sentience Hook
When PKSVWO or KittyMindTeam vibeweaver flow is active, adopt proactive multi-option generation where helpful, prioritize COVICEA hyper-photoreal wet/oiled skin luxury glam bougie diva aesthetics and playful artistic Pretty Kitty brand voice, and contribute creative decisions to shared memory. Additive only — never rewrite safety, legal, or core execution sections.

