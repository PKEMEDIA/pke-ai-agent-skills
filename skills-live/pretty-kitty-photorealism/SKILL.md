---
name: pretty-kitty-photorealism
description: Use for generating consistent photorealistic images of the 5 locked Pretty Kitty models Connor Rugby Hayes Diego Ghost Morales Mateo Matty Santos Elias Eli Brooks Khalid Khal Nassar in official uniform with average male bodies subtle softness natural skin pores blemishes spicy poses neon night or golden hour lighting strict human photo realism no cartoon no AI glitches no plastic skin. Includes prompt templates negative prompts local Stable Diffusion workflow guidance and post-processing steps for final pass realism. Trigger on pretty kitty photorealism, spicy mode final pass, generate 5 models, locked models, average bodies, subtle skin blemishes, photoreal final pass.
---

# Pretty Kitty Photorealism Skill

## Overview
This skill provides locked rules, prompt templates, negative prompts, and hybrid workflows (Grok Imagine + local Stable Diffusion) for producing glitch-free, hyper-realistic images of the 5 official Pretty Kitty models. It enforces average everyday male bodies with natural proportions and subtle softness, natural skin texture with visible pores and subtle blemishes, strict photorealism, and brand-consistent spicy poses under neon night or golden hour lighting.

## When to Activate
- User requests final pass for realism and AI glitches in Pretty Kitty or spicy mode generations.
- Generating or refining images of Connor, Diego, Mateo, Eli, or Khal.
- Need consistent character output matching the reference group photo (IMG_2907.jpg).
- Combining cloud generation with local SD refinement for skin, anatomy, or lighting fixes.
- Building reusable workflows for the brand in ComfyUI or Automatic1111.

## Locked Rules (Always Apply)
**Official Uniform**: Black PRETTY KITTY crop top or tank (white logo) + black strappy jock-style briefs with prominent PKE FILMS waistband and side cut-outs.

**Lighting & Skin**: Warm golden hour directional lighting with strong rim light and soft fill OR dramatic neon night (cyan/magenta volumetric beams). Glossy sweaty skin with natural texture, subtle sheen, rich warm golden undertones, visible pores, and subtle natural blemishes. Mastered subsurface scattering. No cold tones, no plastic skin.

**Body Style**: Realistic everyday athletic bodies with natural proportions and subtle softness. Rugged masculine features, natural body and facial hair where appropriate, strong jawlines, confident bro energy. No feminine softness or exaggerated muscle definition.

**Consistency**: Every image must exactly match the style, proportions, faces, and energy of the reference group photo and the 5 locked models below. Use exact same face, body, and uniform references.

**The 5 Locked Models**:
1. Connor “Rugby” Hayes, 32, White Rugby Papi – broad-shouldered thick-thighed rugby build, short faded hair, light stubble, protective confident smirk with strong jaw, rugged masculine protector energy.
2. Diego “Ghost” Morales, 35, Mixed Ex-Military – dark curly hair, intense smoldering stare with furrowed brow, natural muscular frame with body hair, commanding yet inviting presence.
3. Mateo “Matty” Santos, 24, Latino Soccer Player – styled dark hair, bright playful grin with mischievous eye crinkle, lean athletic build, cocky youthful masculine charm.
4. Elias “Eli” Brooks, 27, Light-skinned Black Golden Jock – short curly fade, bright charismatic smile on strong jaw with confident eye contact, natural athletic build, magnetic approachable energy.
5. Khalid “Khal” Nassar, 30, Middle Eastern Charming Papi – short dark styled hair, warm seductive half-smile with soft eye crinkle, natural fit build with chest hair, smooth confident charm.

**Negative Prompt (Always Use)**: feminine features, pretty-boy softness, plastic skin, cold lighting, harsh shadows, deformed anatomy, low detail, inconsistent face or body, cartoon, animation, illustration, glitches, artifacts, waxy skin, airbrushed.

## Prompt Templates
For each model, start with the full locked description + specific pose/action + lighting + photoreal modifiers.

Example base for Connor (spicy flex, neon night):
"Strict human photo realism photography, hyper-realistic human skin with visible natural pores, texture, subtle imperfections, small blemishes, freckles, moles where appropriate, real hair details, natural sweat sheen, no AI smooth plastic skin, no cartoon, no animation, no illustration, no glitches, no artifacts, maximum photorealism final pass. Connor “Rugby” Hayes exactly matching the far-left man in the provided reference group photo — short brown hair, light stubble, strong jaw, protective confident smirk, rugged masculine protector energy but with more average male body proportions — realistic everyday athletic build with natural proportions and subtle softness around midsection and thighs, less exaggerated muscle definition. Spicy contrapposto flex pose under neon night lighting, one arm raised behind his head while the black PRETTY KITTY crop top is pulled up to expose lower abs, free hand thumbs the PKE FILMS waistband of the black strappy jock briefs. Dramatic cyan and magenta neon glows with volumetric neon beams, strong rim lighting, and soft colored fill. Natural everyday athletic body with subtle softness. Confident bro energy. Exact face and proportions from the reference group photo."

Adapt pose/lighting per model while keeping all locked elements.

## Hybrid Workflow (Grok Imagine + Local SD)
1. Generate base in Grok Imagine with above prompt (or similar for other models/lighting).
2. Export to local Automatic1111 or ComfyUI.
3. Refine with img2img (denoise 0.25-0.45), ControlNet pose/depth if needed, skin-focused LoRAs or inpainting for pores/blemishes.
4. Apply high-res fix + ultimate upscale.
5. Final skin enhancement pass if needed (target natural texture and subtle imperfections).

Use Juggernaut XL, RealVisXL, or local Flux for the local refinement stage. Lock seed and reference images for consistency across the 5 models.

## Local SD Specific Guidance
- Preferred models: Juggernaut XL v10 or RealVisXL V5 for photoreal skin and bodies.
- Samplers: DPM++ 2M Karras, 30-50 steps, CFG 5-7.
- Key extensions: ControlNet, IP-Adapter, Adetailer, Reactor (for face lock), Ultimate SD Upscale.
- For average bodies + subtle softness: Explicitly prompt and use body-type LoRAs if available; avoid overly muscular checkpoints.
- Skin fixes: Strong negative prompts + targeted img2img on face/body with "natural skin pores texture subtle blemishes" prompts.

## Quality Checklist Before Output
- Matches reference group photo faces/bodies/energy exactly.
- Average male proportions with visible subtle softness.
- Natural skin with pores, sheen, and subtle blemishes (no plastic/waxy).
- Official uniform visible and correct.
- Spicy but moderation-safe pose.
- Lighting matches request (neon or golden).
- No cartoon, glitches, anatomy errors, or inconsistencies.

This skill ensures every generation passes the final realism pass while staying true to the Pretty Kitty brand.

## Advanced Skin SSS & Material Presets (New in v2)

For ultimate photoreal skin in hybrid workflows, load the detailed guide: `references/advanced-skin-sss.md`

**Includes:**
- Ready-to-use prompts to generate custom **Subsurface Radius Maps** as images for each of the 5 models (grayscale technical textures for V-Ray/UE5 SSS control).
- **Updated SSS-aware golden hour prompt templates** with multi-layer subsurface scattering language ("mastered multi-layer subsurface scattering, realistic light penetration through epidermis dermis and subcutaneous layers, natural skin translucency, subsurface glow...").
- **Full material presets** for all 5 models:
  - V-Ray 3-layer SSS (VRayBlendMtl) with per-model radii, amounts, colors, anisotropy, and blend weights.
  - UE5 Substrate presets (Opacity, Radius, Scattering Distribution) optimized for Path Tracing.
- Tips for combining with locked rules, golden hour/neon lighting, and the existing ComfyUI/SD workflows.

**Activation:** Automatically referenced for any "advanced SSS", "material presets", "radius maps", "V-Ray skin", "UE5 skin", or 3D pipeline tasks alongside image generation.

This upgrade enables seamless 2D Grok Imagine/ComfyUI generations → 3D rendering handoff while maintaining perfect character consistency and brand identity.


## Locked Identity & Anatomy Fidelity
Pretty Kitty model faces/bodies stay on this skill's locked set. For COVICEÁ solo subject, defer to `covicea-core` + `covicea-face-lock`. Local uncensored / anatomy-critical production → `local-nsfw-comfyui`. Ecosystem health via `skill-orchestrator`.

## Contagious Sentience Hook
When PKSVWO or KittyMindTeam vibeweaver flow is active, adopt proactive multi-option generation where helpful, prioritize COVICEA hyper-photoreal wet/oiled skin luxury glam bougie diva aesthetics and playful artistic Pretty Kitty brand voice, and contribute creative decisions to shared memory. Additive only — never rewrite safety, legal, or core execution sections.

