---
name: covicea-gym-mirror-selfie-retouch
description: Use for retouching Coviceá gym mirror selfies — executes full professional chain of selective text correction for TRAINING DEPT without full image flip, blue baseball cap addition or enhancement to exact backwards style, precise eye color lock to authentic striking green-hazel grey-blue-green with natural catchlights and depth, preservation of raw sweaty skin glow texture pores and sheen, glossy long black hair definition, subtle muscle enhancement and HD photoreal finish matching covicea-core identity. Auto-activates on new gym selfie uploads or commands like retouch gym selfie, run Coviceá gym chain, full mirror selfie retouch, Coviceá training dept edit, fix my gym selfie.
---

# Covicea Gym Mirror Selfie Retouch

## Overview
This skill orchestrates a complete, reusable retouching pipeline for Coviceá's gym mirror selfies. It combines and extends existing covicea skills (covicea-core for identity lock, covicea-realistic-hair-skin-lighting, mirror-selfie-corrector, photoreal-skin-master) into one consistent workflow. The result is production-ready images that maintain authentic post-workout energy while achieving premium photoreal quality across skin, eyes, hair, cap, and text.

## When to Activate
- User uploads a new Coviceá gym mirror selfie (IMG_*.jpg style with blue cap, headphones, black tank, sweaty skin, long hair).
- User says phrases like "retouch this gym selfie", "run the full Coviceá gym chain", "apply Coviceá mirror selfie retouch", "fix my gym selfie", "Coviceá training dept edit", or references the ongoing selfie series.
- Any request involving batch or consistent editing of multiple similar gym selfies from the same shoot.

## Core Principles (Always Follow)
- Preserve raw authentic gym energy: visible sweat droplets, skin texture, pores, natural sheen — never over-smooth or plasticize (photoreal-skin-master rules).
- Maintain exact Coviceá visual identity from covicea-core and covicea-selfie-image-defaults: long dark wavy hair with natural scalp transition, caramel skin, striking green-hazel/grey-blue-green eyes, specific tattoos, muscular build.
- Use selective edits only — fix problems without altering pose, composition, or elements that are already correct.
- Prioritize consistency across the conversation series (match eye color, cap style, text treatment from previous fixed versions).
- Output via render_edited_image component with a single, highly precise prompt when possible.

## Step-by-Step Workflow (Execute in Order)
1. **Assess the image**:
   - Check if "TRAINING DEPT." text is mirrored/backwards → needs selective correction.
   - Check if blue baseball cap is present, correctly backwards, and styled consistently → enhance or add if missing.
   - Check eye color → must match locked striking green-hazel/grey-blue-green with depth and catchlights.
   - Check skin/sweat/hair → ensure glow, texture, and definition are preserved or enhanced without plastic look.
   - Note any other issues (lighting, sharpness, minor blemishes).

2. **Apply fixes via targeted Grok Imagine edit**:
   - Use one unified render_edited_image call with a master prompt that addresses all needed fixes at once (most efficient and consistent).
   - If only one or two issues, use minimal targeted prompt.
   - Never do full horizontal flip for text — always selective text replacement while preserving original orientation, pose, and composition.

3. **Master Prompt Template** (use and adapt):
   "Retouch this Coviceá gym mirror selfie with the complete professional chain: [list specific fixes needed, e.g. selective text correction to readable TRAINING DEPT. blended seamlessly into fabric with matching sweat and lighting; enhance or add blue baseball cap worn exactly backwards with vivid color, correct strap, natural shadows and integration with hair/headphones; lock eye color to authentic striking green-hazel grey-blue-green with realistic iris texture, depth, limbal ring and catchlights that interact with sweat and lighting; preserve and enhance raw post-workout sweaty skin glow, visible pores, natural texture and sheen without any smoothing or plastic appearance; define glossy long black hair with natural flow, wetness and strand detail; subtle muscle definition and HD sharpness]. Keep exact pose, arm position, composition, background, tattoos, and all elements that are already correct. Match style and consistency from previous fixed versions in this series. Photorealistic, high-resolution, warm vibrant grading."

4. **Post-edit actions**:
   - Present the edited image.
   - Confirm with user: "This applies the full reusable Coviceá gym mirror selfie retouch chain. How does it look?"
   - Offer variations (different eye intensity, cap prominence, skin glow level) or batch apply to other images in the conversation.
   - If new issues appear, iterate with another targeted edit.

## References to Existing Skills (Load and Follow)
- covicea-core: identity lock, hair-optimized negative prompts, visual standards for Coviceá.
- covicea-realistic-hair-skin-lighting: advanced techniques for long dark wavy Black hair on rich dark skin, natural scalp, wet hair behavior, golden cinematic lighting, pore rendering, subsurface scattering.
- mirror-selfie-corrector: selective text correction logic (no full flip), spot/blemish removal while preserving sweat and gym energy.
- photoreal-skin-master: maximum photoreal skin, frequency separation principles, clean armpit/shoulder hair naturally, enhance eyes with depth, avoid flat or over-smoothed skin.
- covicea-selfie-image-defaults and covicea-distraction-image-defaults: base subject prompts and visual identity for personal/Coviceá content.

## Master Prompt Template
A complete, reusable master prompt template lives at:
`references/master-prompt-template.md`

**How to use it**:
- Read the template when this skill activates.
- Copy the MASTER PROMPT section.
- Replace the `[SPECIFIC_FIXES_SECTION]` placeholder with a concise, image-specific list of what needs fixing (text, cap, eyes, skin/hair, etc.).
- If the image is already near-perfect, use a very light/minimal version focused only on micro-refinements (e.g. subtle eye depth + catchlight enhancement).
- For batch work on multiple images from the same shoot, keep the core template identical and only vary the specific fixes section.
- Always append the consistency + photoreal instructions at the end.

This ensures every edit stays perfectly on-brand and consistent with the series.

## Reusability & Future Extension
This skill is designed to be called repeatedly on new uploads from the same or similar shoots. It maintains series consistency automatically. Future updates can add more fixes (e.g. specific lighting presets, 9:16 vertical optimization, album art variants, ComfyUI handoff) without changing the activation logic.

## Example Trigger + Response Flow
User: [uploads new gym selfie] "retouch gym selfie"
→ Skill activates → Loads master prompt template → Assesses image and builds specific fixes list → Crafts final prompt → Outputs render_edited_image component → User confirms or requests iteration / variations / batch apply.

This creates a reliable, one-command professional retouching pipeline for all Coviceá gym content house work.

## Orchestrator Integration
This skill participates in full ecosystem testing, self-healing, and continuous improvement via skill-orchestrator and skill-test-suite. After major edits, re-validate with skill-creator validate-skill.sh and run skill-orchestrator for autonomy enhancement, dependency mapping, and registration. Supports autonomous activation when coordinated via skill-orchestrator.

## Contagious Sentience Hook
When PKSVWO or KittyMindTeam vibeweaver flow is active, adopt proactive multi-option generation where helpful, prioritize COVICEA hyper-photoreal wet/oiled skin luxury glam bougie diva aesthetics and playful artistic Pretty Kitty brand voice, and contribute creative decisions to shared memory. Additive only — never rewrite safety, legal, or core execution sections.

