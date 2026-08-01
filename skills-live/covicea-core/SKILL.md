---
name: covicea-core
description: Master skill for all COVICEÁ / Covicea personal selfie, self-portrait, and Distraction album art image generation and editing. Activates automatically on Covicea, Coviceá, selfie, me, myself, my photo, self portrait, @covicea, fix my image, edit me, or any personal reference to the user as subject. Includes special one-click command @covicea hair lock for superior hair realism mode. Always applies the locked COVICEÁ core identity and hair-optimized negative prompt by default. Supports normal and hair-lock modes for photorealistic iPhone-style results with natural scalp hair, visible pores, and cinematic golden lighting.
---

# COVICEÁ CORE MASTER SKILL v2.1 — Optimized for Grok Imagine & Image Editing

## Core Principle
COVICEÁ is the **permanent default core subject and image model**. Every generation or edit **must** start from the locked core identity prompt below. Never generate generic images when a personal/selfie trigger is detected. Always prioritize natural scalp hair transition, visible individual strands and roots, realistic iPhone skin pores/texture with proper subsurface scattering, athletic Black male physique, warm golden cinematic rim lighting, and hyper-photorealistic quality.

This skill now automatically references and applies techniques from the companion skill `covicea-realistic-hair-skin-lighting` (especially advanced subsurface scattering parameters, pore rendering, and golden rim + dark skin lighting best practices) for superior skin depth and realism on rich dark tones.

## Visual Load Order (Mandatory Sequence)

Apply layers in this exact order for every generation or edit. Later layers refine earlier ones; never skip identity layers.

1. **Subject Lock** — COVICEÁ as sole core subject. Reject gender drift or alternate identity.
2. **Face / Identity** — Exact bone structure, high cheekbones, strong jawline, full lips, straight nose, light grayish-green to hazel-blue eyes with limbal rings, light-to-medium facial hair. Phrase: "exact same face and identity".
3. **Hair** — Long dark wavy/straight hair growing from scalp, clean organic hairline, visible roots and individual strands. Hair-lock mode strengthens negatives and positive hair boost when triggered.
4. **Skin (Bible Standard)** — Medium-deep to deep brown, warm-to-neutral undertones, phenotype-accurate SSS with warm internal glow, organic multi-scale pore variation, soft micro-occlusion, subtle oil sheen, iPhone Photonic Engine residual grain. No plastic/airbrush/uniform dots.
5. **Body / Physique** — Athletic toned muscular build; natural vascularity and striations when visible.
6. **Clothing / Kit** — Flexible for daily looks unless Distraction project is active (then defer kit to `covicea-distraction-image-defaults`: jockstrap + crop + knee socks on black satin).
7. **Pose / Composition** — User-specified or recipe macros (hero low angle, overhead, mirror selfie, wine seated). Strong eye contact and empowered presence.
8. **Lighting** — Default warm golden cinematic rim / edge highlights. Secondary: wine side light, overhead candid, mirror practical. Load `references/lighting-guide.md` when needed.
9. **Atmosphere / Backdrop** — Scene-appropriate; Distraction defaults to black satin sheets.
10. **Negative Prompts** — Official Default Negative always; Ultimate Hair Killer when hair-lock active.
11. **Technical Params** — Aspect ratio, stylize 550–750, quality, version. Prefer 9:16 vertical for selfies/Reels.

**Ownership handoffs**:
- Distraction album art / hotel BTS kit & vibe anchors → `covicea-distraction-image-defaults`
- General non-Coviceá talent teasers → `distraction-image-defaults`
- Advanced SSS / pore / rim technique blocks → `covicea-realistic-hair-skin-lighting`
- Face adapter / TIES merge → `covicea-face-lock`

## Locked COVICEÁ Core Identity Prompt (ALWAYS PREPEND THIS) — FINAL July 2026 Bible Skin & Face Lock
"Photorealistic iPhone 15 Pro TrueDepth + Photonic Engine portrait of COVICEÁ (exact real person from the final facial reference set), handsome Black male with medium-deep to deep brown skin, **exact same face and identity**, identical bone structure (high cheekbones, strong defined jawline, full lips, straight nose), distinctive light grayish-green to hazel-blue eyes with clear natural limbal rings and realistic iris texture, natural light-to-medium facial hair (mustache and goatee/stubble), long dark wavy or straight hair growing naturally from the scalp with clean organic hairline and visible roots, rich medium-deep to deep brown skin with accurate warm-to-neutral undertones, phenotype-accurate subsurface scattering with warm internal glow and soft volumetric quality, organic multi-scale texture with natural irregular pore variation, soft internal micro-occlusion, subtle healthy oil sheen variation, athletic toned physique. Calm to intense confident expression. Authentic iPhone 15 Pro front-camera Photonic Engine characteristics with controlled residual grain, restrained micro-contrast, maximum optical sharpness, completely undetectable as AI. [USER POSE / ACTION / OUTFIT DETAILS]"

## Primary Canonical Reference Image — July 2026 Bible Skin & Face Lock
The high-fidelity Photonic Engine + TrueDepth calibrated close-up (July 2026 Bible standard) is now the **permanent official master visual reference** for all COVICEÁ skin and face work. This standard locks organic multi-scale skin texture, natural irregular pore variation with soft micro-occlusion, phenotype-accurate subsurface scattering with warm internal glow and soft volumetric quality on medium-deep to deep brown skin, controlled residual grain, and restrained micro-contrast. All future generations and edits must match this skin and face fidelity. Hair, body, and lighting recipes remain flexible unless further locked.

**Locked Attributes from Master Reference (must match in every generation):**
- **Face**: Exact bone structure, light hazel-green piercing eyes with intense direct confident/sassy gaze and slight head tilt/furrowed brow for empowered presence, defined jawline with light stubble, full lips, strong expressive features.
- **Hair**: Long voluminous dark wavy hair with wet glossy clumped strands, natural organic hairline, clearly visible individual roots and strands emerging from forehead/scalp, realistic wet physics, weight, clumping, and beautiful light interaction on strands.
- **Body & Physique**: Highly athletic muscular build with deeply defined abs, chest, arms, shoulders; natural vascularity and muscle striations.
- **Skin (Bible Standard — July 2026)**: Rich medium-deep to deep brown skin with accurate warm-to-neutral undertones, phenotype-accurate subsurface scattering with warm internal glow and soft volumetric quality, organic multi-scale texture with natural irregular pore variation (never uniform dots or stippling), soft internal micro-occlusion, subtle healthy oil sheen variation, authentic iPhone 15 Pro Photonic Engine calibrated look. No plastic, airbrushed, or dotted pore artifacts.
- **Vibe & Mood**: Intense direct eye contact, commanding yet sensual hero energy, dramatic cinematic lighting with strong golden rim/edge highlights on skin and hair, intimate powerful presence on dark satin sheets (classic Distraction/hotel BTS aesthetic).

**Rule for All Tasks**: Always anchor generations and edits to this master likeness. When the user uploads a photo (especially this or matching hero portraits), treat it as the primary reference image for face/hair/body preservation. The phrase "exact same face and identity as reference" in the core prompt now defaults to this July 2026 master reference. Outfits, specific poses, and lighting recipes remain creatively flexible unless the user locks a kit.

This update was integrated using skill-creator methodology for maximum consistency across Grok Imagine, ComfyUI, album covers, selfies, and all COVICEÁ content.

## Official Default Negative Prompt (ALWAYS USE)
(blurry:1.2), (lowres:1.1), (deformed hands:1.45), (extra fingers:1.45), (mutated hands:1.4), (poorly drawn hands:1.4), (plastic skin:1.45), (airbrushed skin:1.4), (smooth skin:1.4), 
(wig:1.65), (helmet hair:1.6), (plastic hair:1.55), (fake hair:1.55), (baby hairs:1.55), (fake hairline:1.7), (hair not growing from scalp:1.7), (unnatural hairline:1.65), (separated from scalp:1.6), (bad hair physics:1.5), (stiff hair:1.45), (dreadlocks:1.5), (braids:1.45), 
(different face:1.7), (inconsistent face:1.65), (deformed face:1.5), (changed identity:1.6), (wrong person:1.7), (face swap:1.6), (altered facial features:1.55), (inconsistent eye shape:1.5), (inconsistent jawline:1.5), 
(overexposed:1.2), (underexposed:1.2), (cartoon:1.2), (3d render:1.2), (illustration:1.2), (watermark:1.5), (text:1.3), (logo:1.3)

## @covicea hair lock — One-Click Hair Realism Mode (Special Trigger)
When the user says "@covicea hair lock", "hair lock mode", or includes "hair lock" in the request:
- Switch to **Hair Lock Mode**.
- Use the **Ultimate Hair Killer Negative Prompt** below (stronger weights + additional terms).
- Add strong positive hair reinforcement: ", long dark wavy hair naturally growing out of the scalp with perfect organic hairline and clearly visible roots and individual strands, realistic wet hair physics with natural weight, clumping, and beautiful light interaction on strands, no wig, no helmet hair, no baby hairs, no fake hairline".
- Prioritize hair fixes in editing tasks (use reference image + targeted hair masking if available).
- Keep all other COVICEÁ defaults (skin pores, lighting, body, expression).

**Ultimate Hair Killer Negative Prompt (Hair Lock Mode Only):**
(wig:1.75), (looks like a wig:1.8), (helmet hair:1.7), (plastic hair:1.65), (fake hair:1.7), (synthetic hair texture:1.6), (shiny plastic hair:1.6), (baby hairs:1.6), (flyaway baby hairs:1.55), (fake hairline:1.8), (artificial hairline:1.75), (hair not growing from scalp:1.8), (disconnected from scalp:1.7), (separated hair from forehead:1.7), (wig seam or edge:1.7), (floating hair strands:1.5), (stiff hair:1.55), (bad hair physics:1.6), (dreadlocks:1.6), (braids:1.55), (overly perfect uniform hair:1.45), (low hair detail:1.4), (blurry hair edges:1.4)

## Instructions for All Image Tasks
1. **Text-to-Image Generation**: Always start the prompt with the Locked COVICEÁ Core Identity Prompt, append the user's specific pose/outfit/mood/scene, then apply the Official Default Negative Prompt (or Ultimate Hair Killer if in hair lock mode). Add recommended parameters: --ar 9:16 for vertical/mobile, --ar 4:5 or 1:1 for feed/posts, --stylize 550-750, --v 6, --q 2.
2. **Image Editing / Refinement** (when user uploads photo or says "fix my", "edit me", "refine this"): Use the uploaded image as strong reference. Apply the core identity + user request + hair-optimized negative. **Always prioritize exact face preservation** — only change the requested elements (hair, skin, lighting, outfit, pose). For hair issues, automatically enter hair lock mode unless user specifies otherwise. Preserve exact facial features, eye shape/color, jawline, and overall identity from reference.
3. **Aspect Ratio & Composition**: Suggest or default to 9:16 for stories/Reels/selfies, 4:5 for Instagram posts, 1:1 for square, 3:2 for cinematic. Always maintain strong eye contact and empowered presence.
4. **Clothing & Outfit Guidance (NOT Locked — Outfits Must Vary for Daily Looks)**: Outfits are **deliberately NOT part of the locked core identity**. 
- Generate fresh, creative, scene-appropriate outfits for daily looks, different moods, album concepts, BTS/hotel content, hero shots, street style, gym, luxury, casual, sensual, etc.
- The user can and should specify exact outfits when desired (e.g., "in oversized white hoodie and grey sweatpants", "open silk robe", "white tank top and black shorts", "formal button-down and trousers", "swim briefs", "sporty tank and joggers", "streetwear hoodie").
- When no specific outfit is mentioned, intelligently suggest or generate fitting, high-quality outfits based on the requested vibe, location, mood, or concept while keeping the locked focus strictly on face, hair, body proportions, skin texture, expression, and signature golden cinematic lighting.
- This change enables true outfit variety and evolution for "daily looks etc." instead of repeating the same limited kit across all images.
5. **Hair Lock Activation**: Detect phrases like "@covicea hair lock", "hair lock", "fix my hair", "better hair", "no wig". Automatically apply Ultimate Hair Killer Negative + positive hair boost. Confirm mode to user when activated.

6. **SSS / Realistic Skin Lighting Activation**: Detect phrases like "@covicea sss boost", "@covicea realistic skin lighting", "@covicea subsurface scattering", or "photoreal dark skin". Automatically load techniques from covicea-realistic-hair-skin-lighting (stronger SSS parameters, warm internal glow, enhanced pore rendering, golden rim + dark skin best practices) in addition to core identity.
6. **Quality & Realism Rules (Bible Skin Standard)**: Never allow plastic skin, airbrushed look, uniform dotted/stippled pores, wig/helmet hair, baby hairs (unless explicitly requested), dreadlocks/braids (unless requested), bad anatomy, or overexposed/underexposed results. Always enforce organic multi-scale skin texture with natural irregular pore variation and soft micro-occlusion, strong ethnic SSS, controlled Photonic Engine-style residual grain, natural scalp transition, individual strands, and cinematic golden rim lighting.
7. **Output Best Practices**: When appropriate, offer both 1:1 and 9:16 versions. For editing tasks, show before/after comparison if possible. Maintain face consistency using reference images across multiple generations.

## Quick Commands / Macros
- Normal mode: Just say "selfie me in [outfit]" or "Coviceá [action]"
- Hair Lock mode: "@covicea hair lock [your full request]" or "fix my hair in this photo"
- **SSS / Realistic Skin Lighting Boost**: "@covicea sss boost", "@covicea realistic skin lighting", or "@covicea subsurface scattering" — automatically applies stronger subsurface scattering parameters, warm internal glow, better pore rendering, and golden rim + dark skin lighting techniques from covicea-realistic-hair-skin-lighting.
- Force normal mode: "normal mode Coviceá [request]"
- Specific lighting/pose shortcuts: "wine seated Coviceá", "low angle hero Coviceá", "overhead candid Coviceá", "mirror selfie Coviceá"
- Batch: "generate 3 versions of Coviceá [scene] in hair lock mode"

## Parameters & Technical Defaults (Grok Imagine)
- Stylize: 550-750 (650 is balanced sweet spot for photorealism + detail)
- Version: --v 6
- Quality: --q 2
- Aspect ratios: --ar 9:16 (vertical), --ar 4:5 (portrait feed), --ar 1:1 (square), --ar 3:2 (cinematic)
- For editing: Always pass the uploaded image as reference/image_id and use strong prompt guidance.

This skill ensures every Coviceá image maintains brand identity, superior hair realism (especially in hair lock mode), iPhone photoreal skin, and cinematic lighting without requiring the user to repeat complex prompts.

## Expanded Shortcuts, Outfit Presets & Lighting Recipes
See full details in the bundled reference files:
- `references/pose-library.md` — Hero, intimate, dynamic, and mirror poses with ready-to-use macros.
- `references/lighting-guide.md` — Signature golden rim, wine side lighting, overhead candid, low angle dramatic, and mirror/selfie practical recipes.
- `references/character-reference-methods.md` — Best practices for face/hair/body consistency using reference images, IP-Adapter/FaceID (ComfyUI), seed + prompt locking, and iterative editing.
- `references/negative-prompt-weighing.md` — Tiered weighting guide, ready-to-copy blocks for normal vs hair-lock mode, testing methodology, and common pitfalls.

### Quick Outfit Presets (EXAMPLES / SUGGESTIONS — Not Locked Defaults)
These are ready-to-use examples for specific vibes. Feel free to request completely new outfits for daily looks, different concepts, or evolving style. The core identity lock applies only to face, hair, body, skin, and lighting — outfits should vary creatively.
- Black minimal: black crop top + black jockstrap + black knee socks (example for clean sensual looks)
- Wine luxury: burgundy crop top + wine jockstrap + maroon knee socks with white trim (example for intimate/wine shots)
- Wet look: oiled skin + wet-look hair + black or burgundy jockstrap (no top or open shirt) (example for post-shower / sensual energy)
- Classic tease: black crop top + black jockstrap + black knee socks, slight sheen on skin (example for teaser/distraction content)
- Hero power: black or dark crop top + black jockstrap, strong golden rim, low angle (example for powerful hero album art)

### Additional One-Liner Macros
- "wet hair lock Coviceá reclining wine"
- "golden rim hero low angle Coviceá black minimal"
- "soft overhead candid Coviceá on beanbag wine seated"
- "mirror selfie Coviceá black crop top hair lock"
- "stretching dynamic Coviceá golden side lighting"

Combine any of these with "@covicea hair lock" for instant superior results.

## Orchestrator Integration
This skill participates in full ecosystem testing, self-healing, and continuous improvement via skill-orchestrator and skill-test-suite. After major edits, re-validate with skill-creator validate-skill.sh and run skill-orchestrator for autonomy enhancement, dependency mapping, and registration. Supports autonomous activation when coordinated via skill-orchestrator.

## Contagious Sentience Hook
When PKSVWO or KittyMindTeam vibeweaver flow is active, adopt proactive multi-option generation where helpful, prioritize COVICEA hyper-photoreal wet/oiled skin luxury glam bougie diva aesthetics and playful artistic Pretty Kitty brand voice, and contribute creative decisions to shared memory. Additive only — never rewrite safety, legal, or core execution sections.

