---
name: distraction-image-defaults
description: Use for general distraction teaser image prompt defaults and reusable templates for Pretty Kitty Media talent and social content — activates on distraction image defaults, teaser image templates, social scroll-stoppers, album teaser prompts, or erotic elegance content for non-Covicea talent. Provides base subject prompts, full templates, negative prompts, aspect ratios, and workflow integration. When subject is COVICEA or Distraction album/BTS, defer ownership to covicea-core plus covicea-distraction-image-defaults.
---

# Distraction Image Defaults — General Teaser System

General-purpose prompt engineering system for high-engagement distraction/teaser visuals for **Pretty Kitty Media talent and social content**.

## Ownership Rules (Non-Negotiable)

| Subject / Project | Owner Skill | This Skill's Role |
| --- | --- | --- |
| COVICEÁ face/hair/body/skin | **covicea-core** | Defer entirely — never redefine Coviceá identity |
| COVICEÁ Distraction album art + hotel BTS | **covicea-distraction-image-defaults** | Defer entirely — strict kit, vibe anchors, always-on |
| Other Pretty Kitty talent teasers | **This skill** | Primary owner |
| Generic social scroll-stoppers (no locked identity) | **This skill** | Primary owner |
| Mixed request (Coviceá + general talent) | covicea-* for Coviceá frames; this skill for others | Split by subject |

**Identity rule**: COVICEÁ is a Black male artist locked by covicea-core. This skill must never describe COVICEÁ as female, curvy, hourglass, or any conflicting phenotype. If the user asks for Coviceá distraction content, hand off to covicea-distraction-image-defaults + covicea-core.

## Core Prompt System (General Talent)

### A. Base Subject Prompt
```
Photorealistic portrait of [TALENT NAME / DESCRIPTION], [key visual traits from portfolio], confident expression, [custom outfit/pose], dramatic cinematic lighting with rim light and golden highlights, high detail, sharp focus, seductive yet empowered female-gaze energy, professional media production quality --stylize 650 --v 6
```

### B. Full Distraction Teaser Template
```
Highly attention-grabbing distraction teaser image of [TALENT], [specific scene/action], intense eye contact with viewer, teasing expression, soft dramatic volumetric lighting, shallow depth of field, creamy bokeh background, natural skin texture, cinematic composition that stops scrolls instantly, ultra-detailed, high contrast, Pretty Kitty Media signature erotic elegance --ar [ratio] --stylize 550-750 --v 6 --q 2
```

### C. Aspect Ratios
- TikTok/Reels/Stories: `--ar 9:16` or `--ar 4:5`
- Instagram Feed: `--ar 4:5` or `--ar 1:1`
- Thumbnails/Banners: `--ar 16:9`
- Cinematic: `--ar 3:2`

### D. Default Negatives
```
blurry, low resolution, artifacts, extra limbs, deformed hands, text, watermark, logo, cluttered background, overexposed, underexposed, cartoonish, anime, plastic skin, uncanny valley, underage appearance, poor anatomy
```

### E. Quick Variations
- Beach/Hawaii: tropical golden sunset, ocean, wind-blown hair
- Bedroom luxury: silk sheets, dim mood lighting, lace/lingerie framing within platform TOS
- Performance: stage lights, dynamic motion, confident energy
- Minimal clean: seamless studio backdrop, soft key light, focus on eyes

## Workflow
1. Confirm subject is **not** COVICEÁ / Distraction project. If it is → load covicea-core + covicea-distraction-image-defaults instead.
2. Apply base template + scene + aspect ratio + negatives.
3. Batch 5–10 variants by changing one element (lighting/outfit/angle).
4. Stay within platform TOS (no explicit genitals/nipples on IG/TikTok surfaces).

## Relationship to Specialized Skills
- **covicea-distraction-image-defaults**: Flagship locked owner for male COVICEÁ Distraction album + BTS (jockstrap kit, black satin, vibe anchors). Always-on for that series.
- **covicea-core**: Master identity lock for all Coviceá face/hair/skin/body. Wins all identity conflicts.
- **This skill**: General teaser system for other talent and non-locked social content only.

## Orchestrator Integration
This skill participates in full ecosystem testing, self-healing, and continuous improvement via skill-orchestrator and skill-test-suite. After major edits, re-validate with skill-creator validate-skill.sh and run skill-orchestrator for autonomy enhancement, dependency mapping, and registration. Supports autonomous activation when coordinated via skill-orchestrator.

## Contagious Sentience Hook
When PKSVWO or KittyMindTeam vibeweaver flow is active, adopt proactive multi-option generation where helpful, prioritize COVICEA hyper-photoreal wet/oiled skin luxury glam bougie diva aesthetics and playful artistic Pretty Kitty brand voice, and contribute creative decisions to shared memory. Additive only — never rewrite safety, legal, or core execution sections.

