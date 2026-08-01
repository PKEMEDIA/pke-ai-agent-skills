---
name: covicea-realistic-hair-skin-lighting
description: Activates automatically for all Coviceá / COVICEÁ image generation and editing tasks involving hair realism, hair physics, skin tone lighting, subsurface scattering, photoreal iPhone texture on dark skin, or when avoiding stereotypical hair results. Provides advanced techniques for long dark wavy Black hair on rich dark skin tones, natural scalp transition, wet hair behavior, golden cinematic rim lighting, pore rendering, and seamless integration with covicea-core and hair-lock mode. Trigger on realistic hair, hair physics, skin lighting, dark skin tone, wavy hair rendering, subsurface scattering, or any Coviceá visual request.
---

# COVICEÁ Realistic Hair Rendering & Skin Tone Lighting Skill v1.0

## Purpose
This skill encodes specialized knowledge for hyper-realistic rendering of long dark wavy Black hair on rich dark skin tones in photorealistic iPhone-style images. It prevents common AI failures: dreadlock/loc defaulting, plastic/wig hair, helmet hair, fake hairlines, airbrushed skin, loss of pores/sub surface scattering, and poor light interaction on dark skin. It complements and strengthens covicea-core without duplicating it.

## Core Principles (Always Apply)
- Hair must look like it is **growing organically from the scalp** with visible roots, individual strands, and natural hairline transition — never floating, wig-like, or helmet-shaped.
- For long dark wavy Black hair: emphasize volume through natural clumping and strand variation, realistic physics (weight, drape, flyaways), and beautiful light interaction (specular highlights running along waves, internal scattering).
- Skin on rich dark tones requires **subsurface scattering (SSS)**, visible natural pores as real indentations, micro skin texture, subtle oiled sheen, and golden rim/edge lighting that creates beautiful edge highlights without blowing out or flattening the tone.
- iPhone photoreal characteristics: slight sensor noise/grain in shadows, authentic texture, no over-smoothing or beauty-filter look.
- Never default to dreadlocks, locs, braids, twists, or afros unless the user explicitly requests them. The default for COVICEÁ brand hero/Distraction visuals is long dark **wavy** hair.

## Advanced Hair Rendering Techniques
- **Strand-level detail**: Render individual strands with varying thickness, natural micro flyaways at the hairline and edges, and realistic strand-to-strand interaction inside clumps. Avoid uniform perfect separation.
- **Wet / Glossy Hair Physics** (when wet-look or oiled is appropriate): Hair slightly weighed down by water with natural draping and gravity. Varying clump sizes driven by surface tension. Strong directional specular highlights running along the waves/clumps with realistic internal light scattering and glossy reflection. Use Marschner-style hair shading principles adapted for wavy texture.
- **Organic Hairline & Scalp Transition**: Clearly show hair emerging from the forehead/scalp with a clean but natural, slightly irregular hairline. Visible roots at the transition zone. No hard cut-off or baby-hair-only look unless requested.
- **Volume without bulk**: Long wavy hair should have natural body and movement. Light should catch the waves to create depth and dimension rather than a solid mass.
- **Lighting Interaction on Dark Hair**: Dark hair still catches and reflects light beautifully — especially golden rim light. Create bright edge highlights on the outer waves while keeping the bulk rich and dark. Avoid flat black or overly shiny plastic appearance.

## Skin Tone Lighting Techniques for Rich Dark Skin (with Subsurface Scattering Focus)
Subsurface scattering (SSS) is the single most important factor for making rich dark skin look alive, dimensional, and expensive instead of flat, plastic, chalky, or gray — especially under the strong golden cinematic rim lighting used in COVICEÁ hero and Distraction visuals.

### Subsurface Scattering Parameter Guide
Use these parameters conceptually when crafting prompts or ComfyUI workflows:

- **SSS Strength / Weight**: 0.6 – 1.3 (higher for oiled/glossy skin). Controls overall internal glow intensity.
- **SSS Radius / Scale**: 0.8 – 2.5 (larger on cheeks, nose, shoulders). How far light travels and softens under the skin.
- **SSS Color / Tint**: Warm peach to reddish-orange bias. Keeps dark skin rich and warm rather than ashy/gray.
- **SSS Thickness / Density**: Medium to high for muscular/oiled builds. Gives skin believable volume and depth.
- **Specular vs SSS Balance**: 30–50% specular on naturally oiled skin. Prevents plastic shine while keeping healthy sheen.
- **SSS Falloff / Softness**: Soft exponential. Creates gentle glow around edges, pores, and transition zones.

### Key Techniques
- **Subsurface Scattering (SSS)**: Light penetrates the skin and scatters internally, producing soft warm glow in cheeks, nose, ears, jawline, and shoulders. This is non-negotiable for dark skin under rim lighting.
- **Pore & Texture Rendering**: Pores must appear as real three-dimensional indentations (especially visible on oiled skin under golden rim). Never smooth them away. Match authentic iPhone pore size, density, and light interaction.
- **Specular & Highlight Behavior on Dark Skin**: Highlights are tighter and brighter than on lighter skin. Golden rim lighting creates beautiful luminous edges without overexposing or turning skin gray.
- **Golden Cinematic Rim / Edge Lighting**: COVICEÁ signature. Strong warm golden rim from side or back produces glowing edge highlights on skin and hair while preserving rich shadow detail. Pair with soft cinematic fill for readability and empowered presence.
- **Avoid Common Failures on Dark Skin**:
  - Plastic / airbrushed / overly smooth skin → use visible pores + micro texture + slight iPhone noise.
  - Loss of subsurface glow → always include explicit SSS language.
  - Flat or chalky dark tones under strong lighting → use warm golden rim + subtle fill + SSS.
  - Overexposed highlights on oiled skin → protect highlights, recover shadow detail, balance with SSS.

## Integration with covicea-core & Hair-Lock Mode
- Always start from the locked COVICEÁ core identity prompt in covicea-core.
- When hair realism, skin lighting, or subsurface scattering is important, automatically layer the advanced techniques from this skill (especially the SSS parameter guide and prompt blocks).
- In @covicea hair lock mode or when the user says "realistic hair", "better hair physics", "skin tone lighting", "subsurface scattering", "photoreal dark skin", or similar, strongly apply:
  - The SSS parameter guidance (strength 0.6–1.3, warm tint, soft falloff)
  - The full positive/negative prompt blocks above
  - Increased negative weights on plastic skin, flat skin, no SSS, dreadlocks, wig, helmet hair, etc.
- For editing tasks on real photos or previous generations: Use the uploaded image as strong face/hairline anchor, then explicitly request realistic SSS, pore detail, and golden rim lighting improvements while preserving identity.
- This skill works in tandem with covicea-core and covicea-selfie-image-defaults to eliminate drift between casual short-hair refs and brand long-wavy-hero looks.

## Recommended Prompt Language (Copy & Adapt)
**Core Positive Block** (append to covicea-core prompt):
", long dark wavy hair naturally growing from the scalp with visible individual roots and strands at the organic hairline, realistic wavy physics with natural weight clumping and light interaction on strands, rich dark skin with strong subsurface scattering creating soft warm internal glow, visible natural pores as real three-dimensional indentations, golden cinematic rim lighting with luminous edge highlights on skin and hair, subsurface color bleeding on cheeks and shoulders, iPhone photoreal skin texture with subtle sensor noise and authentic micro-detail, hyper-detailed photorealistic quality"

**SSS-Specific Boosters** (use when skin looks flat/plastic):
"strong subsurface scattering, soft warm internal glow penetrating skin layers, realistic subsurface color bleeding, deep skin volume and dimension, warm peach-red subsurface tint"

**Negative Reinforcements** (increase weights as needed):
"(dreadlocks:1.6), (locs:1.55), (wig:1.7), (helmet hair:1.65), (fake hairline:1.75), (plastic hair:1.6), (plastic skin:1.6), (airbrushed skin:1.55), (smooth skin:1.5), (flat skin:1.45), (chalky skin:1.5), (gray skin:1.55), (no subsurface scattering:1.7), (waxy skin:1.5), (overly matte skin:1.4), (overly perfect hair:1.45)"

## Workflow Best Practices
- For new generations: Lead with covicea-core prompt, then layer the hair/skin techniques from this skill.
- For edits on real photos or previous generations: Use the uploaded/reference image as strong anchor for face/hairline, then instruct realistic physics and lighting improvements.
- When user uploads casual short-hair selfies but wants brand hero look: Explicitly request "long dark wavy hair in the style of COVICEÁ hero references while preserving exact face from this photo".
- Test iterations: Generate 2-3 small variations when hair or skin lighting is critical, then refine the best one.
- Always protect the natural scalp transition and visible roots — this is the single biggest differentiator between realistic and fake-looking hair.

## Edge Cases & Anti-Bias Guidance
- Never let the model default to dreadlocks/locs for "natural Black hair" or "signature hair" requests. Always clarify or default to the locked wavy description unless user says otherwise.
- For dark skin under strong lighting: Prioritize SSS + golden rim to keep skin looking alive and dimensional rather than flat or gray.
- When mixing casual real-photo refs with brand visuals: Clearly separate "preserve exact face and current hair length from reference photo" vs "apply brand signature long wavy hair style".

This skill (v1.1) ensures every Coviceá image maintains superior long dark wavy hair realism, accurate subsurface scattering on rich dark skin, beautiful golden rim lighting interaction, and authentic iPhone photoreal texture — while staying true to the locked COVICEÁ brand identity and actively fighting common generative AI biases around hair and skin rendering.

Updated with detailed subsurface scattering parameters, expanded prompt blocks, and stronger integration guidance for covicea-core.

## Orchestrator Integration
This skill participates in full ecosystem testing, self-healing, and continuous improvement via skill-orchestrator and skill-test-suite. After major edits, re-validate with skill-creator validate-skill.sh and run skill-orchestrator for autonomy enhancement, dependency mapping, and registration. Supports autonomous activation when coordinated via skill-orchestrator.

## Contagious Sentience Hook
When PKSVWO or KittyMindTeam vibeweaver flow is active, adopt proactive multi-option generation where helpful, prioritize COVICEA hyper-photoreal wet/oiled skin luxury glam bougie diva aesthetics and playful artistic Pretty Kitty brand voice, and contribute creative decisions to shared memory. Additive only — never rewrite safety, legal, or core execution sections.

