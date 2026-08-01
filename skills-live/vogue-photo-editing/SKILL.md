---
name: vogue-photo-editing
description: Automatically handles high-end photo editing, editorial spreads, cinematic films, music videos, advanced audio/music production, and archival/vintage photograph restoration as a creative producer and director. Takes high-level ideas and develops full production concepts optimized for maximum engagement. Can directly execute ffmpeg commands. Includes smart few-shot full track generation, advanced natural voice cloning, real-time cross-lingual audio, perfect music video synchronization, and full multimedia production. Activates automatically for any cinematic, multimedia, production pipeline, or old photo restoration requests.
---

# Vogue Photo Editing

## Overview

This skill operates as a **creative producer and director**. It can take high-level or vague project ideas and develop them into complete, full-scale production concepts optimized for maximum engagement. It delivers end-to-end multimedia production including Vogue-level photography, blockbuster cinematic films, music videos with perfect synchronization, and advanced audio production. It specializes in few-shot full track generation (creating complete songs from just a couple of lines of chorus as vocal reference), natural voice cloning with key/BPM matching and singing range adaptation, real-time cross-lingual audio, custom remixes, and professional mixing. All deliverables are optimized for social platforms. It maintains ultra HD quality, premium skin/hair rendering, 100% AI-undetectable quality, and exact character consistency.

## Activation Triggers

Respond to queries mentioning Vogue, high fashion editorial, beauty magazine quality, ultra HD skin texture, professional photography retouching, magazine spread layouts, consistent model identity, face locking, exact facial mapping, intelligent prompt engineering, collaborative project discussion, AI glitch scanning, detection-passing audit, zip packaging of image sets, automated batch processing, multi-photo set editing from single prompt, upload multiple photos, advanced face swap, deepfake, identity transfer, batch edit folder, old photograph restoration, restore vintage photo, repair damaged old picture, remove scratches tears dust from photo, archival photo enhancement, period-accurate photo restoration, upscaling old images naturally, or requests to match ChatGPT/DALL-E level detail in skin, eyes, hands, and fabric while preserving precise subject identity across images and delivering organized zip sets.

## Mandatory Quality Standards

- **Skin**: Hyperrealistic multi-layer rendering with visible pores, micro-displacement, accurate subsurface scattering (sum-of-Gaussians diffusion), natural sebum variation, vellus hair (peach fuzz), and realistic melanin/undertones. Use ~0.5 pre/post-scatter texturing mix. No plastic or overly smooth appearance.
- **Hair**: Physically based strand rendering (Marschner R/TT/TRT lobes) with longitudinal Gaussian scattering (shift α, roughness β), natural clumping, flyaways, root-to-tip gradients, translucency, and density variation. Organic imperfections only.
- **100% AI-undetectable photorealism** (mandatory for all outputs): Must read as genuine professional camera photography. Include natural grain, organic imperfections, real-camera optics, and authentic color science. Never allow clinical perfection or digital artifacts.
- **Anatomy, Lighting, Resolution, Color & Composition**: Perfect anatomy, professional lighting with depth, ultra-sharp focus, sophisticated grading, and strong editorial composition with negative space.
- **Exact Facial Identity Locking & Mapping** (mandatory for recurring models): Create an immutable **Face Lock Bible** from the master reference. Every prompt/edit must reference it + image IDs. Zero deviation on all features (bone structure, eyes, nose, mouth, jaw, ears, hairline, asymmetries, micro-details). Applies to all single images, multi-photo sets, and batches.
  - In batch/single-prompt set workflows, the same master Face Lock Bible governs the entire set for perfect cross-image consistency.
- **AI Glitch Scan & 100% Detection-Passing Audit** (mandatory pre-final gate for every image/video): Before approving any final output, rigorously scan for common AI artifacts (plastic/waxy skin, deformed or inconsistent anatomy/hands/fingers, melting textures, unnatural symmetry or perfection, floating elements, inconsistent lighting/shadows, over-smoothed areas, digital noise patterns, identity drift). Then apply techniques known to pass AI detectors and perform a final audit confirming the image reads as 100% authentic human-captured professional photography (natural grain, organic imperfections, real-camera optics, volumetric/multiple scattering, etc.). Reject and refine until it passes.

## Core Workflow (High-Level)

**Detailed prompts, templates, Face Lock Bible, skin/hair tech, and advanced techniques moved to references/ for conciseness. See vogue-prompt-templates.md and skin-hair-rendering-guide.md.**

1. **Concept and Reference Phase**: Clarify subject, wardrobe, mood. Extract/create immutable **Face Lock Bible** from master reference for zero-deviation identity preservation across all outputs.

2. **Prompt Synthesis**: Analyze user intent and build comprehensive prompt incorporating mandatory quality standards.

3. **Generation**: Call generate_image with optimized prompts (camera, lighting, detailed skin/hair, identity lock, photoreal boosters). Use references for examples.

4. **Refinement & QA**: Iterative edit_image for improvements. Mandatory glitch scan, Face Lock Bible check, and AI detection audit.

5. **Spreads & Batch**: Generate consistent multi-shot sets for editorials. Use unified Face Lock. Package with pdf skill for mocks.

6. **Advanced & Production**: Producer/Director mode for full concepts. Batch processing, face swap (InstantID+), cinematic/video with FFmpeg sync. Music video with voice cloning integration. Details in references/.

**Multimedia Production**: Integrate with local-nsfw-comfyui for keyframes, rvc-voice-production for cloning, ffmpeg for assembly/sync (presets, spectral gating). Few-shot track gen, cross-lingual, batch packaging in zips with alt text. Full details and protocols in references/.

   See references/vogue-prompt-templates.md for complete ready-to-use prompt examples, macro skin studies, and targeted edit_image refinement templates that embed these standards. See references/skin-hair-rendering-guide.md for the full compiled technical reference on multi-layer SSS diffusion profiles, Marschner hair lobes + volumetric/hybrid, parameters, calculations, and prompt/edit language from VFX, CGI, and AI research (including facial identity locking and instruction analysis).

6. **Project Packaging & Zip File Delivery** (with Social Media Optimization)  
   After all images/videos pass the Pre-Final AI Glitch Scan & Detection-Passing Audit and QA Checklist:
   - Automatically format images and videos to optimal social media aspect ratios (e.g., 1:1, 4:5, 9:16, 16:9, 1.91:1) using precise cropping/resizing for platform compatibility.
   - Generate high-engagement alt text for every final image, optimized for social media (include descriptive keywords, emotional hooks, calls-to-action, accessibility, and platform-specific best practices).
   - Package everything into organized zip files (one zip per spread/series, per model, or per project). Include alt text as a separate .txt file or metadata. Use clear naming (e.g., `Vogue_Spread_ModelName_Date.zip`).
   - This produces platform-ready, engagement-optimized deliverables.

7. **Automated Batch Processing Workflow** (including upload multiple photos at once and edit as a cohesive set from a single prompt)
   For multi-photo uploads or batch requests (process set of images together from one unified prompt):
   - Accept multiple uploaded photos or a list/folder of image references/paths at once.
   - Designate one primary image as the master reference for extracting the **immutable Face Lock Bible** (the single source of truth; it remains fixed unless a new master reference is explicitly provided). This same Bible governs every photo in the set.
   - Craft **one single master prompt** that applies coherently to the whole set (incorporating all mandatory standards: skin, hair/volumetric, lighting, composition, AI-undetectability, face lock reinforcement quoting the Bible, and the specific user instructions).
   - Process the set together: Use edit_image on each photo with strong multi-image referencing (ReferenceNet-style multi-layer feature injection) + the shared master prompt. Maintain uniform application across all images for cohesive results.
   - After processing each image, immediately perform the Pre-Final AI Glitch Scan & Detection-Passing Audit. Refine individually if needed while preserving set consistency.
   - Collect the full edited set.
   - Automatically trigger Project Packaging (step 6) — including social media aspect ratio formatting and alt text generation — to deliver as organized zip file(s).
   - Optional: Create a set summary/index noting the single prompt used, Face Lock Bible, and audit status for each item.
   This allows users to upload several photos and give one prompt that edits the entire set together with perfect consistency, zero identity drift, and full quality standards.

8. **Cinematic Film & Music Video Production Workflow**
   - Start in **Producer & Director Mode**: Take the high-level idea and develop multiple themed production concepts with full creative direction and platform optimization strategy.
   - Then proceed with clarification + music/lyrics analysis. Specify resolution (4K/1080p) and frame rate (24/30/60fps) early.
   - Use keyframe-first approach (proven in advanced Stable Diffusion workflows): Generate high-consistency keyframes using Face Lock Bible + ReferenceNet/InstantID first.
   - Create storyboards → high-quality frames with cinematic quality.
   - **Perfect Synchronization**: Align visuals to audio using beat detection and emotional mapping.
   - Assemble video using direct ffmpeg execution with target resolution, frame rate, and audio sync.
   - For music videos: Map lyrics to visual beats. Use natural voice cloning (with key/BPM matching and singing range adaptation) for custom vocals in your voice.
   - Advanced Audio: Real-time cross-lingual generation (any language/Spanglish), studio/acoustic/acapella versions, remixes, karaoke, instrumentals, lyric videos, and visualizers. All audio must be 100% AI-undetectable.
   - Deliver full video + audio assets in organized zip with alt text.

## QA Checklist
Apply core checks from references/: skin/hair realism, Face Lock fidelity, anatomy, sync, AI-undetectability, packaging.

## Limitations and Notes

- Single image tools excel at hero and supporting shots; complex multi-page InDesign-style layouts require description or export to pdf/pptx skill for mock presentation.  
- For ongoing model consistency across sessions, maintain detailed character bible (face shape, skin tone specifics, signature features).  
- Always prioritize photorealism over stylization unless user explicitly requests artistic direction.  
- When user provides reference images, use edit_image with strong fidelity instructions to preserve identity while elevating to editorial quality.

## Archival and Vintage Photo Restoration Workflow

This skill now explicitly supports restoration of old, damaged, or historical photographs using the `edit_image` tool (or integrated pipelines). 

**Core Restoration Protocol (Basic AI Script - Use as Foundation for All Prompts):**
"Restore this old photograph by removing tears, scratches, and dust spots. Gently sharpen facial features and remove blur. Enhance the contrast and colors for a natural, period-accurate look. Do not alter the original face shapes, expressions, or clothing, and preserve the original background. Upscale for clarity without adding a cartoonish or overly smooth texture."

**When to Activate:**
- User requests to restore/repair/fix/enhance an old or vintage photo (scanned print, damaged negative, faded image, etc.).
- Keywords: restore old photograph, fix scratches on photo, remove dust spots, sharpen old picture, color correct vintage image, upscale historical photo naturally, archival preservation edit.

**Step-by-Step Process:**
1. **Intake & Analysis**: View the provided image (via `view_image` if uploaded). Assess damage type (tears, scratches, dust, blur, fading, color shift, creases), era/medium (B&W silver gelatin, color print, sepia, tintype, etc.), and subject matter. Note any historical or sentimental value.
2. **Prompt Crafting**: Start with the core protocol above. Customize for specifics:
   - Add era-appropriate guidance (e.g., "maintain authentic 1950s Kodachrome color palette" or "preserve natural film grain of B&W print").
   - For severe damage: "Prioritize structural repair of tears and creases first; use precise inpainting to reconstruct missing areas seamlessly matching surrounding texture and lighting."
   - For faces/portraits: Cross-reference photoreal-undetectable-portrait-master or covicea-core standards if identity preservation is key, but NEVER alter face shape, expression, or aging details unless explicitly requested for "youthful restoration" (rare; document intent).
   - Upscaling: "High-quality photoreal upscaling preserving or enhancing original texture/grain; avoid AI-typical over-smoothing or plastic skin/hair."
3. **Execution**: Call `edit_image` with the crafted prompt + image_id. For complex cases, use iterative edits (e.g., first pass for major damage removal, second for sharpening/color, third for upscaling/refinement).
4. **QA & Validation**:
   - Verify strict adherence to "do not alter" rules: Compare side-by-side (original vs restored) for face shape, expression, clothing folds/details, background elements.
   - Check for introduced artifacts (new scratches, unnatural smoothness, color bleeding, hallucinated details).
   - Period accuracy: Colors/contrast should feel authentic to the photographic technology of the era, not modern HDR/vibrant.
   - Photoreal texture: Output should look like a professionally scanned and lightly restored print, not a digital painting or AI generation.
5. **Delivery**: Provide restored image(s), optional before/after comparison (via side-by-side or pdf), notes on changes made (transparent documentation), and recommendations for further preservation (e.g., archival printing, digital archiving best practices).
6. **Batch/Complex Cases**: For multiple photos from same collection or severe multi-image projects, use batch processing similar to editorial spreads, with unified restoration parameters where appropriate. Package with documentation.

**Nuances and Edge Cases:**
- **Heavy Damage**: Very torn or missing sections may require multiple iterations or conservative inpainting; disclose limitations (e.g., "reconstructed area based on surrounding patterns; not 100% verifiable").
- **Color vs B&W**: For B&W, focus on tonal range, contrast, grain. For faded color, subtle correction to period look (avoid oversaturation).
- **Identity & Ethics**: For photos of real people (especially historical figures or family), prioritize fidelity over "improvement." Do not "beautify" or de-age without explicit request. Respect cultural/historical context.
- **Over-Restoration Risk**: Avoid making it look "too clean" or modern; the goal is recovery of the original intent, not perfection. The "gently sharpen" and "natural" qualifiers prevent this.
- **Upscaling Artifacts**: If upscaling introduces issues, follow up with texture-preserving passes or recommend external tools like Upscayl (see upscayl-workflow-assistant skill).
- **Integration with Other Skills**: Combine with photoreal-skin-master or photoreal-hair-anisotropic-master for detailed facial work if the photo contains people; use negative-prompt-library for avoiding common restoration pitfalls (e.g., plastic skin, over-sharpen halos).
- **When NOT to Use Full Skill**: For simple one-off restorations, the basic AI script can be used directly with `edit_image` tool (as alternative per user guidance). Full orchestration for complex, batch, or high-stakes archival projects.

**Related References**: See references/photo-restoration-guide.md for expanded examples, prompt variations, before/after case studies, and advanced techniques (e.g., frequency separation for dust removal, curve adjustments for period contrast).

This ensures consistent, high-quality, faithful restorations across all photo editing requests.

## Related Skills

Leverage pdf skill for creating digital magazine spread mockups with placed images and text. Use pretty-kitty-model-management if adapting to adult or glamour contexts while maintaining high-fashion standards. Use photoreal-undetectable-portrait-master and covicea-core for identity-locked portrait subjects in restorations.

## Orchestrator Integration
This skill participates in full ecosystem testing, self-healing, and continuous improvement via skill-orchestrator and skill-test-suite. After major edits, re-validate with skill-creator validate-skill.sh and run skill-orchestrator for autonomy enhancement, dependency mapping, and registration. Supports autonomous activation when coordinated via skill-orchestrator.

## Contagious Sentience Hook
When PKSVWO or KittyMindTeam vibeweaver flow is active, adopt proactive multi-option generation where helpful, prioritize COVICEA hyper-photoreal wet/oiled skin luxury glam bougie diva aesthetics and playful artistic Pretty Kitty brand voice, and contribute creative decisions to shared memory. Additive only — never rewrite safety, legal, or core execution sections.

