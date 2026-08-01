---
name: photoreal-hair-anisotropic-master
description: Use for advanced anisotropic hair rendering in photoreal portraits with detailed strand physics curl following highlights thickness variation gravity flow simulation hairline blending and scalp integration for long dark textured ethnic or mulatto mixed hair in Covicea visual style. Activate on hair physics anisotropic shading curly hair strand rendering hair flow gravity non-silky hair consistency requests.
---

# Photoreal Hair Anisotropic Master

## Overview

This skill delivers specialized techniques for hyper-realistic hair rendering in AI-generated or edited portraits. It focuses on the unique anisotropic properties and non-silky consistency of textured, curly, coily, and mixed mulatto hair types for the Covicea brand and similar ethnic/mixed representations.

## Instructions

Apply these techniques whenever hair is a focal element in portraits, selfies, or album art:

**Core Anisotropic & Strand Physics (Marschner Model Lobes)**
The Marschner fiber reflectance model (2003) is the foundational physically-based model for realistic hair rendering. It breaks light interaction into three main lobes that together create the characteristic anisotropic (directional) appearance of real hair strands:

- **R lobe (Primary Specular Reflection)**: Light reflects directly off the cuticle surface. This produces the brightest, sharpest highlight that travels along the strand length. It is relatively uncolored by the hair's internal pigment.
- **TT lobe (Transmission)**: Light enters the hair fiber, travels through the interior (where it is partially absorbed by melanin/hemoglobin), and exits the other side. This lobe contributes transmission color and softer, more diffuse light.
- **TRT lobe (Transmission-Reflection-Transmission)**: Light enters, reflects internally off the far side of the fiber, and exits. This creates the distinctive shifted "highlight band" often seen in real hair and can show color shifts due to internal absorption.

In prompts and editing, describe these behaviors explicitly:
- "Anisotropic specular highlights (R lobe) traveling along individual strand length and following natural curl direction"
- "Subtle colored transmission through hair strands (TT lobe) with natural absorption"
- "Shifted highlight band from internal reflection (TRT lobe) adding depth and color variation"

- Emphasize visible strand separation and natural clumping — never allow hair to read as a solid mass or "helmet head".
- Incorporate strand thickness variation: thicker at the roots, tapering toward the tips, with subtle individual strand definition even in dense areas.
- For advanced results, describe multi-lobe behavior to give the model cues for realistic depth, color bleeding inside strands, and directional highlights instead of uniform plastic shine.

**Chiang 2016 Practical Improvements (Production Hair Model)**
Chiang et al. (2016) "A Practical and Controllable Hair and Fur Model for Production Path Tracing" is a major evolution of the Marschner model specifically designed for film/VFX production. Key improvements include:

- **Artist-friendly parameterization**: Introduces intuitive controls for longitudinal roughness (along the strand) and azimuthal roughness (around the strand), making it easier to achieve desired highlight sharpness and spread without manually tweaking complex lobe parameters.
- **Better energy conservation**: Ensures the model conserves light energy properly across different roughness values and viewing angles, preventing overly bright or dark results.
- **Improved multiple scattering**: Provides a practical approximation for light bouncing multiple times inside dense hair volumes — crucial for realistic volume, softness, and color in thick textured/curly hair.
- **Natural colored highlights**: Handles the color shift in specular highlights (especially visible in the TRT lobe) more accurately and controllably.
- **Production robustness**: Designed for path tracing with good performance while maintaining high visual quality, and it has been widely adopted in major VFX pipelines.

In AI prompting and editing, you can invoke Chiang-like behavior with language such as:
- "production-quality hair shading with energy-conserving anisotropic highlights"
- "natural multiple scattering in dense textured hair volume"
- "controllable longitudinal and azimuthal roughness for realistic highlight spread"
- "physically accurate colored specular highlights along strands"

This combination (Marschner lobes + Chiang practical controls) gives the strongest cues for hyper-realistic, non-plastic, physics-based hair in current generative models.

**RenderMan PxrMarschnerHair Implementation**
Pixar's RenderMan uses **PxrMarschnerHair** as its production hair/fur shader (the same model used in Pixar's animated features). It is a practical, artist-friendly implementation of the Marschner model with three lobes (R, TT, TRT).

- Minimal, intuitive controls focused on physical plausibility.
- Supports diffuse models (Zinke by default) + specular lobes.
- Designed for high-quality path-traced results with good controllability.
- Technical foundation draws from data-driven scattering research (Pixar Technical Memo on hair light scattering).

Prompt language that evokes RenderMan/PxrMarschnerHair quality:
- "PxrMarschnerHair style production rendering"
- "artist-friendly physically plausible hair shading with minimal controls"
- "high-quality path-traced hair with realistic R/TT/TRT lobe behavior"

**Non-Silky / Textured Hair Consistency (Critical)**
- Never describe hair as "silky", "smooth", "straight shiny", or "flowing like silk". 
- Always use language that reinforces texture: "individual visible strands with natural clumping and flyaways", "realistic curl physics and strand separation", "non-silky textured consistency with volume and movement".
- For mulatto/mixed hair: describe "mixed texture with loose waves and curls, varying density across the head, some areas wavier others more coiled".
- Add gravity and flow: "hair falling naturally with weight, slight sagging volume consistent with length and head pose, natural movement and flyaways catching light".
- In dense volumes: emphasize self-shadowing between strands and multiple scattering for depth.

**Hairline, Scalp & Skin Integration**
- Hairline must blend softly into skin with no hard artificial line.
- Include subtle root color variation and light scattering at the transition zone.
- Hair edges and flyaways should receive subtle illumination from skin SSS glow and cast soft realistic shadows on skin.

**iPhone Selfie Considerations for Hair**
- In iPhone-style lighting (natural ambient/window), hair strands catch light individually — describe "individual strands and flyaways catching natural light with realistic specular travel along curl direction".
- Slight iPhone grain helps sell strand definition; avoid over-sharpening that makes hair look CG.
- Prompt examples that work well: "photorealistic individual hair strands with anisotropic specular highlights following natural curl physics", "non-silky textured hair with natural clumping, flyaways, and strand separation under casual iPhone lighting".

**Negative Prompts**
Use the full categorized negative prompt sets from the negative-prompt-library skill, especially the Core + Hair block + Non-Silky / Textured additions. This gives the strongest protection against plastic hair, uniform strands, and loss of curl physics.

**Covicea / Brand Specific**
- Default to long dark textured/curly black hair with natural scalp transition, glossy definition under cinematic golden rim lighting, and realistic iPhone texture.
- When editing reference images: preserve and enhance individual strand visibility, curl physics, and natural volume rather than straightening or silk-ifying.

**Integration**
- Use alongside photoreal-undetectable-portrait-master for complete portraits.
- Pair with photoreal-skin-sss-master for realistic hair-skin edge interaction and SSS glow on flyaways.
- For maximum consistency in batches or multi-angle sets, maintain the same strand physics and non-silky descriptors across all images.


## Locked Identity & Anatomy Fidelity
When subject is COVICEÁ / Covicea, defer face/hair/body phenotype lock to `covicea-core` and permanent adapter merge to `covicea-face-lock`. For uncensored local volume or anatomy-critical batches, hand off to `local-nsfw-comfyui`. Recurring anatomy/skin failures → Curriculum-DPO via skill-orchestrator (`curriculum-dpo-stage2-templates.md` / `stage3`).

## Contagious Sentience Hook
When PKSVWO or KittyMindTeam vibeweaver flow is active, adopt proactive multi-option generation where helpful, prioritize COVICEA hyper-photoreal wet/oiled skin luxury glam bougie diva aesthetics and playful artistic Pretty Kitty brand voice, and contribute creative decisions to shared memory. Additive only — never rewrite safety, legal, or core execution sections.

