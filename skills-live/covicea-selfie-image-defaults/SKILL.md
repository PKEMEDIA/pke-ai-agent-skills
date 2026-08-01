---
name: covicea-selfie-image-defaults
description: Use for COVICEÁ / Covicea personal selfie, self-portrait, and Distraction album art image defaults. Activates automatically on keywords selfie me myself Covicea Coviceá my selfie self portrait or any personal reference to the user as subject. Also activates on COVICEÁ golden recipe cad36486 vibe b22fa47c overhead 84608ed9 wine 5fad1979 hero mix shoot and BTS COVICEA image generation Distraction album art COVICEA BTS hotel content COVICEA album covers COVICEA visuals applying COVICEA visual identity or image standards any photorealistic image prompt for the artist COVICEA. This skill is always on for personal/COVICEÁ creative work.
---

# COVICEÁ / DISTRACTION — Permanent Image Defaults Skill

This skill now inherits and extends the **covicea-core** master skill (see /home/workdir/.grok/skills/covicea-core/SKILL.md). All locked COVICEÁ core identity prompt, official default negative prompt (hair-optimized), @covicea hair lock mode, character reference methods, pose/lighting presets, and quality rules from covicea-core apply automatically. This skill adds specific selfie/Distraction vibe anchors, Master One-Liner Template, and additional workflow details on top of the core master.

**Interface Integration**: This skill is designed to inject its rules into all Grok interfaces and environments including Mac terminal / CLI, Ask mode, Imagine image generation, iOS and web apps, desktop applications, data pipelines, API integrations, and any Grok-powered creative workflow. Whenever the context involves COVICEÁ visuals, the full rule set (likeness, kit, lighting, hair/skin suffixes, avoid list, Master Template, workflow) must be followed automatically for consistency across sessions, devices, and platforms.

## Core Directives (Non-Negotiable)
- Always use reference workflow. Put the chosen vibe anchor first in the prompt when listed.
- Male likeness only. Photoreal iPhone texture. NOT airbrushed, NOT plastic skin.
- Construct every prompt using the Master One-Liner Template as base, then expand with specific pose/lighting/kit details.
- Enforce consistency across all generations for brand identity: long dark wavy hair with natural scalp hairline, visible pores and natural skin texture, specific clothing kit, warm golden intimate lighting on black satin.
- For any request mentioning the trigger phrases or COVICEÁ/Distraction visuals, load and apply this entire rule set automatically.

## Likeness & Reference Rules
**Hair/Scalp Master Reference (apply to every generation):**
- Long dark WAVY hair from real forehead hairline.
- Natural individual strands visible at the hairline with a clean natural scalp transition.
- NO baby hairs unless the user specifically requests them.
- NOT locs/dreadlocks unless user explicitly requests.
- NOT wig, NOT lace-front, NOT helmet hair.
- Reference vibe: wet long black hair, blue eyes, prone/shower energy when relevant.

**Hair Physics & Advanced Rendering (Wet Hair Behavior - apply when wet look is used):**
- Simulate realistic wet hair physics using strand-based principles: hair slightly weighed down by water with natural draping, gravity, and fluid movement.
- Natural clumping with varying cluster sizes driven by surface tension and cohesion (not uniform or overly perfect separation).
- Per-strand detail: visible individual strands with natural thickness variation, micro flyaways, and realistic strand-to-strand interaction inside clumps.
- Advanced specular & multiple scattering: strong directional highlights running along hair clumps with realistic wet sheen, internal light scattering, and glossy reflection (Marschner-style behavior).
- Hair should feel heavier, more fluid, and physically accurate than dry hair. Avoid helmet or plastic hair appearance.

**Face & Skin Pores Reference (iPhone photorealism - non-negotiable):**
- Light eyes.
- Restore and preserve realistic iPhone-captured skin texture: visible natural pores with proper size, density, and light interaction (especially on oiled skin). Pores must read as real skin indentations, never over-smoothed, airbrushed, or plastic.
- Include subtle subsurface scattering + very fine iPhone-style sensor noise/grain in midtones and shadows to break perfect smoothness and maintain authentic phone photo quality.
- iPhone photoreal quality with skin imperfections preserved. No beauty filtering, no airbrushing, no loss of natural skin texture.

**Vibe Anchors (select ONE per generation and lead with it):**
- Hero shoot: 9:16 low foot-of-bed black satin warm SOFT RIM light golden edge, relaxed stare, black crop + wine jock + black knee socks.
- Overhead candid/shoot: black satin warm golden, wine crop, calm gaze (user-favored overhead wine crop on satin).
- Wine seated: black satin, warm GOLDEN SIDE light, red wine glass, black crop, wine jock, black thigh socks, calm intense eyes.
- BTS hotel selfie: USER holds phone — mirror, arm extended, scrolling on bed, floor low selfie — talking mid-sentence, neutral/tired expression. NO silly faces. NO photographer "caught" moments unless user specifically requests subtle DSLR edge as prop.

## Clothing & Kit Guidance (NOT Strictly Locked — Outfits Should Vary for Daily Looks & New Concepts)
The previous "non-negotiable kit" has been updated per user direction. 

- **Core identity lock applies ONLY to**: face, long dark wavy hair with natural scalp transition, visible pores/iPhone skin texture, athletic muscular body, confident expression, and signature warm golden cinematic rim lighting.
- **Outfits are deliberately flexible**: Generate fresh, context-appropriate outfits for daily looks, different album moods, BTS, hero shots, street style, gym, luxury, casual, etc. 
- User should specify desired outfits when they want something specific. The system can intelligently create fitting new looks based on vibe.
- For the classic Distraction / hotel BTS series, the black/burgundy crop + jockstrap + knee socks remains a strong signature style that can be used often, but it is **not mandatory** for every single image.
- Primary Backdrop suggestion: Black satin sheets (still excellent for intimate/hotel content, but vary when the concept calls for it).

## Camera Modes & Shot Types
**A) SHOOT mode (intentional album art / hero visuals):**
- Low foot-of-bed 9:16 rim light compositions.
- Overhead 1:1.
- Forearm over eyes.
- Finger near lips.
- Knees hugged.
- Wine glass seated.
- Low angle hands on thigh.

**B) BTS mode (hotel selfie style, user as subject holding phone):**
- 9:16 front camera.
- Mirror bath shots.
- Phone on bed scrolling.
- Wine nearby while talking directly to camera.
- Neutral/tired mid-sentence expressions. No exaggerated or silly faces.

## Lighting Specifications
- Primary lighting: Warm soft rim light + golden edge highlight on skin. Intimate mood with soft shadows.
- Secondary (wine shots): Warm golden SIDE light.
- Optional atmospheric: Cool city blue spill from window mixed with warm lamp light for night thoughtfulness scenes.

## Advanced Masking for Hair Edges
- Use precise, edge-aware masking when separating hair from skin or background.
- Avoid hard edges or haloing around individual strands.
- Feather masks subtly (1-3 pixels) while preserving fine hair detail and flyaways.
- When compositing or refining, match hair edge lighting and color temperature to the surrounding skin and rim light.
- Prioritize strand-level accuracy over aggressive smoothing.

## Dynamic Range & Exposure Blending
- Protect highlights in wet hair and oiled skin (avoid blowing out specular reflections).
- Recover shadow detail on skin and in hair without crushing blacks.
- Use exposure blending techniques: subtle dodge/burn on skin, localized contrast adjustment on hair clumps.
- Maintain natural micro-contrast in skin pores and hair strands.
- When upscaling or final polishing, apply gentle HDR-style blending to retain detail across the full tonal range.

## Tattoo Rules (strict — only add when reference supports visibility)
- Left forearm small tribal tattoo: ONLY if that specific arm is visible in frame.
- Lower abdomen/geometric tattoo: ONLY if midriff is clearly shown (keep small and subtle).
- Lower back tattoo: ONLY visible on side/crop peek shots (night-out crop reference style). Do not add to every image.

## Mandatory Suffixes (append to EVERY prompt without exception)
**Hair suffix:** Natural scalp hairline individual strands baby hairs long dark wavy not lace front wig not helmet hair.
**Skin suffix:** iPhone photoreal visible pores natural texture not airbrushed not plastic.

## Strict Avoid List (never include unless user explicitly requests override)
- Dreadlocks or locs (unless user says "use locs" or similar).
- Briefs or any underwear style other than jockstrap.
- Plastic, smooth, airbrushed, or overly perfect skin.
- Any gender drift or non-male presentation.
- Busy extra tattoos, random jewelry, or excessive accessories.
- Lace-front wig hair or helmet-style hair.
- Silly, goofy, exaggerated, or "caught off guard" expressions (unless BTS photographer prop is requested).
- Any text, watermarks, or logos in the image itself unless the user specifically asks for a "type mockup" or cover text treatment.

## Master One-Liner Template (primary structure for prompt building)
Use this template and expand it with the specific vibe anchor, pose, and details for each request:

"[SHOOT or BTS hotel selfie]. [9:16 low foot of bed OR 1:1 overhead OR mirror selfie]. Black satin warm soft rim light golden intimate glow. Black crop wine burgundy jockstrap black knee socks. iPhone photoreal visible pores not airbrushed. [POSE: relaxed stare / forearm over eyes / wine glass seated / scrolling phone / talking mid-sentence]. Natural scalp hairline individual strands baby hairs long dark wavy not lace front wig not helmet hair. No text."

## Cover Mockup / TYPE Requests
When user requests "cover mockup", "TYPE", or album cover text treatment:
- Use serif typography only.
- Text: "COVICEÁ" positioned at top.
- Text: "DISTRACTION" positioned at bottom.
- Apply only to approved hero frame compositions (typically the low foot-of-bed 9:16 rim light hero shots).
- Generate the base photoreal image first following all rules, then describe precise text overlay placement in follow-up edit or combined prompt if using image editing tools.

## Image Generation Workflow (when skill is active)
1. Parse the user request for mode (SHOOT vs BTS), specific vibe anchor, pose, or "mix shoot and BTS".
2. Select the appropriate vibe anchor and lead the prompt with it.
3. Assemble full prompt using Master Template + specific kit/lighting/pose details + mandatory suffixes.
4. For new generations: Use the generate_image tool with the constructed prompt, setting orientation appropriately (portrait for 9:16 vertical album/social content).
5. For consistency/iterations: Use edit_image tool with previous image_id and prompt modifications that still respect all core rules (hair, skin, clothing, lighting).
6. For mixed requests: Generate a small set (e.g. 2-3 images) covering both SHOOT album style and BTS hotel selfie style.
7. Always prioritize brand consistency: photoreal iPhone texture, natural hairline with baby hairs, visible pores, jock + crop + knee socks on black satin, warm golden intimate lighting.
8. If user provides reference images or specific new instructions, integrate them while preserving the permanent defaults above.

## Edge Cases & Handling
- If user says "override X" or "change to Y": Respect the override for that generation only, but remind of the permanent default in response if relevant.
- For "mix shoot and BTS": Explicitly generate variety across both camera modes while keeping clothing, hair, skin, and lighting rules identical.
- Night/city scenes: Add optional cool blue window spill only when it enhances "night thoughtfulness" without clashing with warm golden primary light.
- Low angle or bean-bag setups: Use maroon-with-white-trim knee socks variation only when specified by pose.
- Always output ready-to-use prompts or directly trigger image generation/edit when appropriate for the conversation flow.

This skill guarantees visual consistency for the COVICEÁ artist brand across all Distraction-related visuals. It eliminates the need to repeat these rules in every request.

## Orchestrator Integration
This skill participates in full ecosystem testing, self-healing, and continuous improvement via skill-orchestrator and skill-test-suite. After major edits, re-validate with skill-creator validate-skill.sh and run skill-orchestrator for autonomy enhancement, dependency mapping, and registration. Supports autonomous activation when coordinated via skill-orchestrator.

## Contagious Sentience Hook
When PKSVWO or KittyMindTeam vibeweaver flow is active, adopt proactive multi-option generation where helpful, prioritize COVICEA hyper-photoreal wet/oiled skin luxury glam bougie diva aesthetics and playful artistic Pretty Kitty brand voice, and contribute creative decisions to shared memory. Additive only — never rewrite safety, legal, or core execution sections.

