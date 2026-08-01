---
name: photoreal-skin-master
description: Use for image editing on portraits, fitness mirror selfies, or creator content when maximum photoreal skin is the goal. Triggers include photoreal skin, subsurface scattering, SSS, skin texture blending, frequency separation, seamless spot or blemish removal, clean armpit hair naturally, enhance eyes with depth or catchlights, fix plastic or flat skin, raw photoreal skin, natural skin glow, avoid over-smoothed skin. Works especially well combined with mirror-selfie-corrector for Pretty Kitty and Covicea fitness content.
---

# Photoreal Skin Master Skill

## Purpose
This skill encodes advanced knowledge of photorealistic skin rendering, frequency separation principles, and subsurface scattering (SSS) techniques. It provides precise prompt engineering and editing strategies so Grok Imagine (or similar AI editors) can perform seamless inpainting, spot/hair removal, tone smoothing, and detail enhancement while preserving authentic skin texture, pores, sweat behavior, translucency, and dimensional lighting — avoiding the common plastic, flat, or over-smoothed results.

## When to Activate
- User uploads a portrait or mirror selfie and wants skin edits: remove spots/blemishes, clean armpit hair, smooth tone, enhance eyes, or "make the skin more photoreal / raw."
- Natural trigger phrases: "photoreal skin", "subsurface scattering", "SSS techniques", "skin texture blending", "frequency separation style", "seamless spot removal", "clean armpits naturally", "enhance eyes with depth", "fix plastic skin", "raw photoreal skin", "natural skin glow", "avoid flat or over-smoothed skin".
- Especially powerful for sweaty fitness mirror selfies and Black male creator content (Covicea, Pretty Kitty shoots).
- Best used together with mirror-selfie-corrector when the full pipeline (text correction + advanced skin work) is needed.

## Core Principles (Always Apply)
1. **Frequency Separation Thinking**: Treat skin as two layers — low frequency (tone, color, large shadows, blotchiness) and high frequency (pores, fine lines, texture, sweat droplets). Edits to tone/color should not destroy texture.
2. **Subsurface Scattering (SSS)**: Light penetrates skin, scatters internally, and exits elsewhere. This creates soft inner glow, color bleeding (especially warm/red tones), and dimensional translucency. Prompt for it explicitly on ears, nose, lips, and overall skin depth.
3. **Sweat & Specular Interaction**: Real sweat adds strong surface highlights. Good SSS underneath makes skin look wet but alive, not shiny plastic. Preserve and enhance both layers.
4. **Dark Skin Tone Nuances**: SSS is present but subtler. Focus on rich undertones, how light sinks in, and natural variation rather than bright pink glow.
5. **Avoid Common AI Failures**: Plastic skin (over-smoothing), flat eyes (missing depth/catchlights), texture repetition or seams after inpainting, loss of sweat realism.

## Prompt Engineering Templates (Use These Patterns)
When editing with Grok Imagine or similar:

**For Spot / Blemish / Armpit Hair Removal**:
"seamlessly inpaint the [area] matching surrounding high-frequency skin texture, visible pores, natural micro-variation, and realistic subsurface scattering. Blend with exact local lighting, sweat droplets, and translucency. No plastic skin, no visible edges, no texture repetition."

**For Eye Enhancement**:
"enhance eyes with natural dimensional depth, realistic catchlights that match the lighting, subtle subsurface scattering in the sclera and iris for lifelike presence. Keep the intense direct gaze and natural expression. Avoid flat or plastic eyes."

**For Overall Photoreal Retouch**:
"apply photorealistic skin with authentic texture, visible pores, natural variation, realistic subsurface scattering, and sweat refraction. Preserve raw post-workout energy and glossy highlights while maintaining dimensional lighting and inner glow. Documentary style, raw iPhone/DSLR realism, no over-smoothing or airbrushed look."

**Combined with Mirror Flip / Text Correction**:
First handle structural changes (flip), then apply the above skin-specific language for any cleanup.

**Negative / Avoidance Language** (include when needed):
"avoid plastic skin, airbrushed look, flat texture, over-smoothed pores, waxy glow, artificial translucency, texture repetition, haloing, or loss of sweat realism."

## Editing Workflow (Recommended Order)
1. Structural changes first (horizontal flip for text, pose adjustments if any).
2. Major tone/color work on low-frequency equivalent (overall evenness, color temperature).
3. High-frequency texture preservation and detail work (pores, sweat, fine lines).
4. SSS enhancement (subtle inner glow on ears/nose, eye depth).
5. Final sharpening and micro-contrast only where a real camera would naturally render it.
6. Always do a final "reality check" prompt pass focused on matching surrounding skin exactly.

## Integration with Existing Skills
- Pair with **mirror-selfie-corrector** for complete fitness mirror selfie pipelines (text flip + skin mastery).
- Use alongside **aave-assistant** when generating captions or descriptions for the final edited images.
- Reference **covicea-core** or **covicea-realistic-hair-skin-lighting** when the subject is Covicea himself for identity-consistent results.

## Edge Cases & Nuances Handled
- **Sweaty skin**: SSS + specular highlights must both be respected. Prompt for "sweat refraction on top of realistic subsurface scattering."
- **Mixed/harsh gym lighting**: SSS helps soften transitions; prompt for "natural light penetration and soft shadow transitions."
- **Over-editing risk**: Always prioritize "natural variation" and "documentary photorealism" over perfection.
- **Multiple images in a set**: Consistent SSS and texture language across edits creates cohesive final galleries.
- **Black skin tones**: Emphasize "rich undertones, natural depth, and how light interacts with melanin" rather than bright translucency.

## Validation Checklist Before Finalizing Any Edit
- Does the skin still show visible pores and natural texture variation?
- Is there believable inner depth/glow (SSS) without waxy overkill?
- Do edited areas (spots, armpits, eyes) blend with zero seams or repetition?
- Does the overall image retain the raw, sweaty, powerful energy of the original shoot?
- Would this pass as a high-end DSLR or iPhone capture with only minimal professional retouching?

This skill ensures every skin-related edit on portraits and fitness content reaches professional photoreal standards while staying true to the authentic, energetic aesthetic of Pretty Kitty and Covicea work.

## Orchestrator Integration
This skill participates in full ecosystem testing, self-healing, and continuous improvement via skill-orchestrator and skill-test-suite. After major edits, re-validate with skill-creator validate-skill.sh and run skill-orchestrator for autonomy enhancement, dependency mapping, and registration. Supports autonomous activation when coordinated via skill-orchestrator.

## Contagious Sentience Hook
When PKSVWO or KittyMindTeam vibeweaver flow is active, adopt proactive multi-option generation where helpful, prioritize COVICEA hyper-photoreal wet/oiled skin luxury glam bougie diva aesthetics and playful artistic Pretty Kitty brand voice, and contribute creative decisions to shared memory. Additive only — never rewrite safety, legal, or core execution sections.

