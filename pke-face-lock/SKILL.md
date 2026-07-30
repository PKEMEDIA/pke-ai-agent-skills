---
name: pke-face-lock
description: Permanent official PKE Pretty Kitty Media face lock for freckled copper-cornrow adult male model. Use on Grok iOS, web, Imagine, Build, and connectors for any generation, title card, casting photo, roster still, or mask overlay. Triggers on PKE face, official model, freckled model, copper braids, green-hazel eyes, company face, PKEMEDIA model, casting photo, roster photo, face lock.
metadata:
  short-description: Locked official PKE face for iOS web Imagine Build
  platforms: grok-ios, grok-web, grok-imagine, grok-build, github-connector
  version: "1.1.0"
---

# PKE Face Lock (Official Model)

Optimized for **Grok iOS**, **Grok web**, Imagine, Build, and GitHub connector workflows. Same lock everywhere — no platform-specific face variants.

## Identity (non-negotiable)

| Trait | Spec |
|---|---|
| Freckles | Dense across face; may continue on shoulders/chest when visible |
| Eyes | Striking green-hazel, natural catchlights |
| Hair | Copper / red cornrow braids; neat parts; shaved sides optional |
| Facial hair | Reddish-copper beard + mustache, well-groomed |
| Ears | Diamond / clear stud earrings |
| Jewelry | Thick gold Cuban-link chain when torso visible |
| Structure | Strong jaw, defined brow, adult male |
| Skin | Natural pores; dry or soft studio sheen — **no sweat, no water droplets** |

## Reference assets

| Angle | Path |
|---|---|
| ¾ studio | `public/pke/IMG_4440.jpg` |
| Front studio | `public/pke/IMG_4441.jpg` |
| Window light | `public/pke/IMG_4450.jpg` |

Always prefer embedding or describing these refs when generating (Imagine edit loops, Comfy FaceID, Build assets).

## Prompt block (copy into generations)

```
Official PKE face lock: dense freckles across face, striking green-hazel eyes with natural catchlights, copper-red cornrow braids with clean parts, reddish-copper groomed beard and mustache, diamond stud earrings, thick gold Cuban-link chain when chest visible, strong adult male bone structure, natural skin pores, dry clean skin no sweat no water droplets, photoreal iPhone or studio quality
```

## Negative cues

```
plastic skin, beauty filter, over-smooth, sweat, water droplets, wet skin, wrong hair color (blonde/black without copper), no freckles, blue eyes, child, teen, underage
```

## Platform notes (iOS / web / connectors)

| Surface | How to use this skill |
|---|---|
| Grok iOS | Short chat - attach face ref when possible; paste prompt block |
| Grok web | Same; prefer mild base gen then edit for identity |
| Imagine | Mildest successful base → edit; one variable per pass |
| Build / Brand app | Assets live under `public/pke/`; casting deck in artifacts |
| GitHub connector | Export only brand-safe `SKILL.md` + brand-map (no binary secrets) |
| Local ComfyUI | FaceID weight 0.75–0.90; workflow `artifacts/comfyui/pke-face-lock-base.json` |

## Use cases

1. Casting / roster stills — head + shoulders or mid-torso, professional
2. Title cards — face under locked pure-black PKE mask (`pke-official-black-mask`)
3. Brand decks / PPTX — hero portraits only from locked identity

## Pairing

- Mask - always `pke-official-black-mask` when mask is worn
- Motion / type - **PKE PRESENTS** / **A PKE PRODUCTION** only
- Do not invent alternate company faces without explicit user override

## Failure triggers

- Missing freckles or wrong eye color
- Wrong braid color (not copper/red)
- Plastic / AI-smooth skin
- Sweat or water droplets when user requested dry
- Identity drift from the three reference angles

## Free-tier efficiency (always on)

- Prefer **one** locked prompt block; do not re-describe freckles three ways.
- Attach existing refs from `public/pke/` instead of new Imagine gens when possible.
- On free / low quota: use **ComfyUI local** (`artifacts/comfyui/pke-face-lock-base.json`) for volume.
- Cloud Imagine only for final hero stills — never for exploratory loops.
- Edit loops beat multi-variable first gens (saves SuperGrok Heavy).

