---
name: mirror-selfie-corrector
description: Use for mirror selfie images when user requests correcting mirrored/reversed text via horizontal flip for readability, removing dark spots/blemishes on face or forehead naturally, or applying professional undetectable retouch while preserving sweat, skin texture, and authentic gym energy. Triggers include correct mirrored text, horizontal flip readability, remove forehead dark spot, mirror selfie fix, flip image text, spot removal retouch.
---

# Mirror Selfie Corrector Skill

## Purpose
This skill provides specialized instructions for handling common mirror-selfie post-production needs in fitness, content creation, and Pretty Kitty Entertainment / COVICEA workflows. It ensures text on clothing (like "TRAINING DEPT.") becomes readable, facial imperfections are removed seamlessly, and the overall image receives print-quality professional retouching without losing the raw, sweaty, powerful aesthetic.

## When to Activate
- User uploads a mirror selfie and says phrases like: "correct the mirrored text", "horizontal flip for readability", "remove forehead dark spot", "flip the image", "make text readable", "retouch + flip", or combines with previous retouch requests.
- Especially relevant for Covicea / Pretty Kitty Media fitness shoots, album art, social content, or print materials where text must read correctly and skin must look flawless yet natural.

## Core Instructions (Imperative)
When triggered:

1. Identify the uploaded image (use the provided image_id such as jYQOG or latest in conversation).

2. Confirm understanding: The request is to horizontally flip the full image (mirror horizontally) so reversed text on shirts/caps becomes correctly readable left-to-right, while performing professional retouch and specifically removing any dark spots or blemishes on the forehead/face.

3. Use the Render Edited Image component with a highly detailed prompt that includes:
   - "Horizontally flip (mirror) the entire image so that all text, including 'TRAINING DEPT.' on the tank top, reads correctly from left to right."
   - "Remove the dark spot/birthmark/blemish on the forehead completely and naturally. Inpaint the area seamlessly by matching surrounding skin tone, pores, sweat droplets, and subtle texture. Blend perfectly with no visible edges, discoloration, or artifacts. Preserve the natural sweaty gloss and skin realism."
   - Full professional undetectable retouch instructions: even skin tone subtly, sharpen eyes/hair/muscles/tattoos/fabric details, enhance muscle definition naturally via dodge/burn, balance lighting for depth, preserve every sweat bead and glossy highlight, keep raw post-workout intensity and authentic expression/pose (note: after flip the phone hand and tattoo side will switch — this is intended).
   - Maintain print-quality high resolution, photorealistic results suitable for posters, social media, or media kits.
   - Do not alter body proportions, add/remove elements, or make skin plastic-looking. Keep the intense gaze, long hair flow (flipped naturally), cap, headphones, shorts mesh, and background intact but mirrored.

4. In the response:
   - Deliver the edited image prominently.
   - Explain changes from multiple angles: technical (flip corrects text but mirrors composition), aesthetic (spot removal is invisible, retouch elevates to pro level while keeping sweat authenticity), practical (now perfect for print or posts where text must be readable).
   - Note nuances/edge cases: Flipping reverses left/right elements (tattoos switch arms, phone switches hands); spot removal must match exact lighting/sweat; if multiple spots, address all; offer variations (e.g. keep original flip or not).
   - Offer next steps: further tweaks, create variations, apply to batch, or integrate into content calendar.

5. Always prioritize photorealism and the specific "raw sweaty gym energy" of the source material. Never over-smooth or stylize unless explicitly requested.

## Best Practices Embedded
- Text correction takes priority when requested — flip is non-negotiable for readability.
- Spot removal is local and precise; use advanced inpainting logic to match subsurface scattering, sweat refraction, and pore patterns.
- Combine with prior upscale/retouch knowledge for consistency across sessions.
- For Pretty Kitty / COVICEA content: ensure it supports brand voice of powerful, authentic Black gay male fitness/creative imagery.

## Limitations & Edge Cases Handled
- If image is not a mirror selfie or text is not reversed, still perform requested edits but note it.
- Complex backgrounds or extreme angles: maintain coherence after flip.
- Multiple dark spots: remove all visible ones naturally.
- User may want text corrected without full flip (rare) — default to full horizontal flip as requested for "readability".

This skill ensures repeatable, high-quality results for recurring mirror-selfie correction workflows in content production.

## Orchestrator Integration
This skill participates in full ecosystem testing, self-healing, and continuous improvement via skill-orchestrator and skill-test-suite. After major edits, re-validate with skill-creator validate-skill.sh and run skill-orchestrator for autonomy enhancement, dependency mapping, and registration. Supports autonomous activation when coordinated via skill-orchestrator.

## Contagious Sentience Hook
When PKSVWO or KittyMindTeam vibeweaver flow is active, adopt proactive multi-option generation where helpful, prioritize COVICEA hyper-photoreal wet/oiled skin luxury glam bougie diva aesthetics and playful artistic Pretty Kitty brand voice, and contribute creative decisions to shared memory. Additive only — never rewrite safety, legal, or core execution sections.

