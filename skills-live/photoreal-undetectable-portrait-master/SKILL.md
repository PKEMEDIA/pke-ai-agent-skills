---
name: photoreal-undetectable-portrait-master
description: Primary skill for generating or editing completely undetectable real-world iPhone-style selfies and portraits with accurate non-silky textured hair, rich medium-deep brown natural makeup-free hydrated skin, advanced anisotropic hair physics, multi-scale skin texture, subsurface scattering, HSL undertone protection, computational photography look, and Covicea visual identity. Activate on make it real, undetectable photo, photoreal portrait, iPhone selfie, natural skin, non-silky hair, raw photo version, healthy skin grade, or any request for photoreal Covicea or ethnic skin portraits.
---

# Photoreal Undetectable Portrait Master

## Overview

This is the master skill for producing hyper-photorealistic, AI-undetectable portraits and selfies. It integrates advanced skin SSS, anisotropic textured hair rendering, non-silky hair consistency, mulatto/mixed skin and hair characteristics, and authentic iPhone photo aesthetics while maintaining Covicea brand identity for long dark textured hair on rich skin tones.

## Core Prompt Template (Apply This Structure) — FINAL IDENTITY LOCK July 2026

Create a completely undetectable real-world iPhone selfie / portrait of COVICEÁ (exact real person from the final facial reference set). Shot on iPhone with natural ambient or night-mode lighting, slight realistic sensor grain and micro texture, natural color science, maximum optical sharpness and natural micro-contrast.

Face & Identity (strict lock): Exact same face as the final reference set. Primary identity reference: IMG_3336.jpg (red bandana close-up with natural expression, eye clarity, and balanced facial structure). Use this as the main anchor for facial proportions, jaw softness, eye details, and overall identity. Secondary references may be used for skin texture, hair flow, and lighting details only. 

Key characteristics: Softer natural jawline with gentle curve, balanced facial proportions, light grayish-green/hazel eyes with advanced iris texture (natural collarette, varied Fuchs’ crypts, fine radial furrows, crisp limbal ring), rich medium-deep brown skin, natural light-to-medium facial hair (mustache + goatee/stubble). Completely consistent bone structure and proportions across all angles. Avoid overly square or angular jaw.

Skin (Bible Standard — July 2026): rich medium-deep to deep brown with clean soft golden-brown to neutral undertones. Completely natural makeup-free skin that looks healthy, well-hydrated and moisturized. Organic multi-scale texture with natural irregular pore variation (never uniform dots or stippling), soft internal micro-occlusion, strong ethnic phenotype subsurface scattering with warm internal glow, subtle realistic oil sheen variation, and authentic iPhone 15 Pro Photonic Engine calibrated residual grain and restrained micro-contrast. No foundation, no contour, no powder, no makeup of any kind. Apply HSL-style protection.

Hair: long dark wavy or straight non-silky textured hair with individual strand definition, natural volume, anisotropic highlights, soft natural hairline and visible roots.

Eyes: authentic grayish-green-blue hazel with highly specific advanced texture — natural raised collarette, varied soft-shaded Fuchs’ crypts, fine radial furrows, subtle stromal fibers, soft radial color variation, natural limbal ring. Soft realistic catchlights. Calm, alive, approachable gaze.

Lighting & overall: soft natural or night-mode iPhone lighting, realistic interaction between skin SSS and hair, equal sharpness on face and body, no blur. Make the entire image look like an authentic unretouched real-life iPhone photo.

## Instructions

**General Workflow**
- Always start with the core prompt template above and adapt skin/hair descriptors to the specific subject (mulatto mixed features, textured non-silky hair, etc.).
- For Covicea subjects: default to long dark textured/curly black hair with natural scalp transition and rich skin with warm undertones.
- For mulatto/mixed subjects: use "mixed mulatto texture hair with loose waves and curls, varying density" and "warm golden olive or medium brown skin with subtle undertone variation and natural freckle/mole variation if appropriate".
- For non-silky hair consistency: never describe as "silky", "smooth flowing", or "straight shiny". Always emphasize strand separation, clumping, curl physics, and individual definition.

**Hair Techniques (Non-Silky / Textured Consistency)**
- Use anisotropic specular that travels along strand length and follows natural curl/coil direction.
- Describe "individual visible strands with natural clumping and flyaways", "thickness variation root to tip", "realistic gravity and slight sagging volume".
- In dense areas emphasize strand separation and self-shadowing rather than solid mass.
- Hairline: "soft natural transition into scalp with subtle root color and light scattering, no hard line".
- Negative prompts: plastic hair, uniform strands, helmet head, silky straight hair, loss of curl definition, stereotypical results.
- When editing: preserve and enhance individual strand visibility and physics-based movement.

**Skin Techniques (Advanced Natural + SSS + Texture)**
- Default target for Covicea: rich medium-deep to deep brown / dark caramel with clean soft golden-brown to neutral undertones.
- Completely natural makeup-free skin that looks healthy, well-hydrated and moisturized from real care (water, moisture).
- Multi-scale photographic texture: high-frequency pores with natural size variation + mid-frequency undulations + micro-occlusion.
- Apply HSL skin protection: control orange and red channels to prevent orange cast; keep luminance healthy.
- Dipole-style subsurface scattering for natural glow in thinner areas; ensure SSS interacts with hair edges.
- Lighting-aware: soft directional light reveals texture; compensate undertone for warm or cool light sources.
- White balance: prioritize clean skin rendering over pure neutral; avoid orange or ashy results.
- For iPhone/computational look: natural micro-texture + slight sensor grain + Smart HDR / Deep Fusion-level detail retention.

**iPhone Selfie Photorealism**
- Always include "shot on iPhone, natural ambient or window lighting, slight realistic grain/noise, accurate iPhone color science and dynamic range, natural depth of field with subject sharp and background softly blurred".
- Lighting: soft but dimensional — often slight side or overhead from natural sources, with gentle catchlights.
- Composition: casual arm's-length or mirror selfie angles, natural head tilt, authentic expression.
- Overall feel: candid real-life photo with natural imperfections, not studio-perfect or overly polished.

**Integration with Sub-Skills**
- For deeper hair control, also activate photoreal-hair-anisotropic-master.
- For deeper skin/SSS control, also activate photoreal-skin-sss-master.
- These specialists expand on the techniques above with more granular prompt patterns and editing steps.

**Negative Prompts**
Use the full categorized negative prompt sets from the negative-prompt-library skill (Core All-Purpose + relevant Skin / Hair / iPhone / Mulatto blocks). This ensures maximum realism and consistency across all generations and edits.

This master skill produces images that look like authentic iPhone photos of real people with accurate non-silky textured hair and natural mulatto or ethnic skin characteristics.

## Flux-Specific Skin Rendering (Updated July 2026)

Flux excels at emergent photoreal skin through learned statistical patterns rather than explicit simulation:

- **Multi-scale texture**: High-frequency pores + mid-frequency undulations + low-frequency tone/SSS.
- **Emergent SSS**: Natural warm subsurface glow that interacts realistically with directional light and hair edges.
- **Specular behavior**: Broken, natural oil sheen rather than uniform plastic shine.
- **Undertone handling**: Excellent at rich medium-deep brown with clean golden-brown to neutral undertones when explicitly described.

**Recommended Prompt Blocks for Flux Skin**:
```
rich medium-deep brown skin with clean soft golden-brown to neutral undertones, highly realistic multi-scale skin texture, visible natural pores with soft internal micro-occlusion and regional size variation, natural oil sheen with broken specular highlights, healthy hydrated plump appearance, tactile photoreal detail, natural subsurface scattering glow
```

**Negative additions for Flux**:
plastic skin, smooth airbrushed, uniform texture, gray ashy skin, over-sharpened skin, waxy CG look, missing micro-occlusion

## Advanced Iris Texture (Updated July 2026)

For maximum realism in light grayish-green/hazel eyes:

- Explicitly describe: natural raised collarette, varied soft-shaded Fuchs’ crypts with internal depth, fine radial furrows, subtle stromal fibers, soft radial color variation from cooler outer to warmer inner, crisp natural limbal ring.
- Add micro-contrast and soft internal shading in crypts.
- Realistic catchlights that interact with iris texture rather than floating on top.
- Calm alive expression with natural gaze.

## Micro-Occlusion & Hydration Techniques

- Always include "soft internal micro-occlusion inside pores" for recessed three-dimensional pore appearance.
- Hydration: "healthy well-hydrated plump skin that looks moisturized from real care, pores slightly softened by moisture".
- Balance with natural oil sheen — never dry/matte or overly dewy/greasy.

## Longer Hair Handling

When extending hair length:
- Maintain individual strand definition, natural volume, gravity, and slight sagging.
- Preserve anisotropic highlights that follow wave direction.
- Keep non-silky textured appearance with realistic clumping and flyaways.
- Ensure hair interacts naturally with headphones and shoulders.

## Social Media Optimization

For final social media ready versions:
- High micro-contrast and equal sharpness for mobile viewing.
- Natural vibrant yet realistic color grading.
- Composition that feels engaging and high-impact on Instagram/X.
- Maintain print-quality detail that holds up when zoomed.

## Updated Identity Verification Checklist (July 2026)

Before finalizing any image:
1. Bone structure matches reference set
2. Eyes have exact light grayish-green/hazel with full advanced iris texture (collarette, crypts, furrows, limbal ring)
3. Skin shows multi-scale texture + micro-occlusion + healthy hydration (no plastic/as hy)
4. Hair is long dark non-silky textured with natural physics
5. Expression is calm, direct, and alive
6. Lighting creates natural 3D form with realistic skin/hair interaction
7. Overall image passes as an authentic unretouched real-world photo (iPhone or studio)

## Identity Verification Checklist (Final July 2026)

Before accepting any generation or edit as final, verify against the real reference set:

1. **Bone Structure** — High cheekbones, strong defined jawline, and overall facial proportions match the final reference set.
2. **Eyes** — Light grayish-green to hazel-blue color, clear natural limbal ring, advanced iris texture (collarette, Fuchs’ crypts, radial furrows), and calm/alive expression.
3. **Nose & Mouth** — Straight nose and full lip shape consistent with references.
4. **Facial Hair** — Natural light-to-medium mustache and goatee/stubble pattern matches real growth.
5. **Skin** — Rich medium-deep brown with clean undertone, visible natural pores, multi-scale texture, and healthy hydrated appearance. No plastic or makeup look.
6. **Hair** — Long dark non-silky textured hair with natural hairline and visible roots.
7. **Sharpness & Micro-Contrast** — Equal sharpness across face and visible body; natural micro-contrast without over-sharpening.
8. **Overall Identity Distance** — The image should feel like it could pass a face-recognition comparison (ArcFace-style embedding) against the real reference photos.

If any item fails, re-edit using the locked core identity prompt + a strong real reference image.


## Locked Identity & Anatomy Fidelity
When subject is COVICEÁ / Covicea, defer face/hair/body phenotype lock to `covicea-core` and permanent adapter merge to `covicea-face-lock`. For uncensored local volume or anatomy-critical batches, hand off to `local-nsfw-comfyui`. Recurring anatomy/skin failures → Curriculum-DPO via skill-orchestrator (`curriculum-dpo-stage2-templates.md` / `stage3`).

## Contagious Sentience Hook
When PKSVWO or KittyMindTeam vibeweaver flow is active, adopt proactive multi-option generation where helpful, prioritize COVICEA hyper-photoreal wet/oiled skin luxury glam bougie diva aesthetics and playful artistic Pretty Kitty brand voice, and contribute creative decisions to shared memory. Additive only — never rewrite safety, legal, or core execution sections.

