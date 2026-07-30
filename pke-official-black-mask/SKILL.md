---
name: pke-official-black-mask
description: Locked official pure-black full-grain leather spiked bunny mask for all PKE Films Pretty Kitty Media content on Grok iOS, web, Imagine, Build, and connectors. Triggers on PKE mask, official mask, black bunny mask, pretty kitty mask, spike mask, title card mask, pure black spikes, leather mask texture.
metadata:
  short-description: Locked pure-black spiked PKE mask for all platforms
  platforms: grok-ios, grok-web, grok-imagine, grok-build, github-connector
  version: "1.1.0"
---

# PKE Official Black Mask (Locked)

Same mask lock on **Grok iOS**, **web**, Imagine, Build, and exported skill packs. No chrome variants.

## Form lock

- Full-head coverage; elongated snout; defined chin
- Tall upright ears
- Continuous dense **pure-black** matte pyramid spikes on outer ear edges
- High-density pure-black pyramid spikes on cheeks, jawline, face perimeter
- Vertical center line of small black studs / rhinestones on forehead
- **No silver, chrome, or metallic spikes**

## Material lock

- Semi-aniline full-grain black cowhide
- Visible irregular micro-pores; organic shifting grain
- Soft matte to low-satin — never patent plastic shine
- Pure deep black only (no blue/brown cast)

## Lighting lock

- Soft key + strong raking side light for leather grain
- Subtle rim separation from dark background
- Prefer pure black / near-black field for title cards

## Consolidated prompt block

```
Official PKE full-head black leather bunny mask: tall upright ears with continuous dense pure-black matte pyramid spikes along entire outer ear edges, high-density pure-black pyramid spikes covering cheeks jawline and face perimeter, vertical center forehead line of small black studs and rhinestones, pronounced elongated snout, premium semi-aniline full-grain black cowhide with visible micro-pores and organic grain, soft matte low-satin finish, pure deep black only — no silver chrome metallic spikes, no plastic patent shine
```

## Quality / failure

| Fail if | Fix |
|---|---|
| Chrome / silver spikes | Force pure black matte pyramids |
| Plastic patent look | Full-grain pores + matte language |
| Sparse spikes | Continuous dense coverage |
| Wrong ear height | Tall upright ears |

## Platform notes

| Surface | Tip |
|---|---|
| Imagine | Edit from locked mask still; do not recolor spikes |
| iOS / web chat | Paste consolidated block; attach mask ref when available |
| ComfyUI | Keep mask LoRA/prompt; FaceID still from face skill when model visible under mask |

## Pairing

Use with `pke-face-lock` when a model wears the mask. Title text - Heavy Geometric Sans white **PKE PRESENTS** / **A PKE PRODUCTION**.
