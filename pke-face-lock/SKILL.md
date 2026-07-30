---
name: pke-face-lock
description: >
  Permanent official PKE / Pretty Kitty Media face lock for the freckled
  copper-cornrow adult male model. Use on any generation, title card, casting
  photo, roster still, or mask overlay where this is the company face. Triggers
  on PKE face, official model, freckled model, copper braids, green-hazel eyes,
  company face, PKEMEDIA model, casting photo, roster photo, face lock.
metadata:
  short-description: "Locked official PKE face identity for all brand generations"
---

# PKE Face Lock (Official Model)

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

## Prompt block (copy into generations)

```
Official PKE face lock: dense freckles across face, striking green-hazel eyes with natural catchlights, copper-red cornrow braids with clean parts, reddish-copper groomed beard and mustache, diamond stud earrings, thick gold Cuban-link chain when chest visible, strong adult male bone structure, natural skin pores, dry clean skin no sweat no water droplets, photoreal iPhone or studio quality
```

## Negative cues

```
plastic skin, beauty filter, over-smooth, sweat, water droplets, wet skin, wrong hair color (blonde/black without copper), no freckles, blue eyes, child, teen, underage
```

## Use cases

1. **Casting / roster stills** — head + shoulders or mid-torso, professional
2. **Title cards** — face under locked pure-black PKE mask (`pke-official-black-mask`)
3. **Brand decks / PPTX** — hero portraits only from locked identity

## Pairing

- Mask: always `pke-official-black-mask` when mask is worn
- Motion / type: Brand Guidelines Motion System (PKE PRESENTS / A PKE PRODUCTION)
- Do not invent alternate company faces without explicit user override

## Failure triggers

- Missing freckles or wrong eye color
- Wrong braid color (not copper/red)
- Plastic / AI-smooth skin
- Sweat or water droplets when user requested dry
- Identity drift from the three reference angles
