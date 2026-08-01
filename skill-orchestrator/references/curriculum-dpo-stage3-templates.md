# Curriculum-DPO Stage 3 Caption Templates — Skin / Oil / SSS / Identity Under Intensity

**Canonical reference** for Stage 3 (Hard — Advanced Erotic Fidelity + Skin Physics).  
Use after Stage 2 anatomy has stabilized.  
Parent guide: `curriculum-dpo-nsfw.md`  
Stage 2 pairs: `curriculum-dpo-stage2-templates.md`  
Pair automation: `automated-pair-scoring.md`

All subjects are legal-age consenting adults. Locked phenotype = COVICEÁ / Pretty Kitty Media brand face.

Last updated: 2026-07-28

---

## Shared Locked Character Block (every WIN caption)

```
photorealistic portrait of COVICEÁ, exact same face and identity, medium-deep to deep brown skin with warm-to-neutral undertones, light grayish-green to hazel-blue eyes with natural limbal rings, long dark wavy hair growing from the scalp with clean organic hairline and visible roots, athletic toned muscular physique, natural skin pores and subtle oil sheen, phenotype-accurate subsurface scattering
```

Stage 3 assumes Stage 2 anatomy already holds. Focus WIN language on **pores, oil physics, SSS, fabric–skin contact, and identity under intensity**. LOSE language names the exact physics/identity failure.

---

## D. Skin pores + oil physics

### D1. Heavy oil with visible pores (macro / mid)
**WIN**  
`[LOCKED BLOCK], heavy glistening oil on skin with individual visible pores and natural irregular pore variation, realistic oil pooling and highlight breakup, soft micro-occlusion in skin folds, phenotype-accurate subsurface scattering with warm internal glow, fine art male study, dramatic rim light, no plastic or airbrushed surface`

**LOSE**  
`[LOCKED BLOCK], heavy oil that wipes out all pore detail, painted-on uniform sheen, plastic or waxy skin under oil, flat specular highlights, no subsurface scattering, airbrushed plastic surface`

### D2. Sweat + oil mix (gym / exertion)
**WIN**  
`[LOCKED BLOCK], mixed sweat and oil with natural droplet variation, pores still readable under moisture, realistic wet-skin specular response, healthy oil sheen only where light hits, photorealistic iPhone texture on dark skin, cinematic lighting`

**LOSE**  
`[LOCKED BLOCK], plastic wet look, uniform shiny coating with no pores, melted skin under moisture, fake droplet sprites, over-smoothed airbrushed skin`

### D3. Dry-to-oiled transition / partial sheen
**WIN**  
`[LOCKED BLOCK], selective oil sheen on shoulders and chest with dry matte skin elsewhere, clear pore texture in both regions, natural transition, believable light interaction, professional male boudoir, strong negative fill`

**LOSE**  
`[LOCKED BLOCK], inconsistent plastic patches, oil that erases texture in one region only, hard cut between shiny and matte with no natural blend, flat skin`

---

## E. Subsurface scattering (SSS) under dramatic light

### E1. Warm internal glow on medium-deep brown skin
**WIN**  
`[LOCKED BLOCK], phenotype-accurate subsurface scattering with warm internal glow and soft volumetric quality on medium-deep to deep brown skin, light wrapping through the ear and nose edge, natural redness in thin tissue, organic multi-scale pore variation, Rembrandt lighting`

**LOSE**  
`[LOCKED BLOCK], chalky or flat dark skin with no internal glow, hard cut shadow with no light transport, grayish dead undertone, plastic surface, no SSS`

### E2. Rim light + SSS interaction
**WIN**  
`[LOCKED BLOCK], strong golden cinematic rim light with visible subsurface scatter along the rim edge, warm glow bleeding into shadow, pore detail retained in both key and rim, fine art sensual male study`

**LOSE**  
`[LOCKED BLOCK], rim light that only creates a hard white outline, no scatter into the skin, plastic rim, loss of pore detail under the rim, flat silhouette`

### E3. Close-up facial SSS
**WIN**  
`[LOCKED BLOCK], close facial crop, accurate SSS in the nose, ears, and lip edges, warm internal glow, natural limbal rings and iris texture preserved, multi-scale pores on cheeks and forehead, iPhone Photonic Engine residual grain`

**LOSE**  
`[LOCKED BLOCK], close facial crop with plastic mask-like skin, no internal glow, dead flat cheeks, identity soft or drifted, over-smoothed pores`

---

## F. Identity under high intensity

### F1. Close spicy crop — face holds
**WIN**  
`[LOCKED BLOCK], close intimate crop at high erotic intensity, exact same face and identity fully preserved, eye color and bone structure locked, long dark wavy hair with visible roots, natural skin pores and oil sheen, professional male boudoir, dramatic light`

**LOSE**  
`[LOCKED BLOCK], close intimate crop at high erotic intensity, face drifted or swapped, wrong eye color, softened jawline, identity collapse, plastic skin, generic features`

### F2. Low-angle power + intensity
**WIN**  
`[LOCKED BLOCK], low-angle power pose at high intensity, exact same face and identity, phenotype lock retained under dramatic lighting and oil, correct anatomy from Stage 2, rich skin texture and SSS, cinematic rim light`

**LOSE**  
`[LOCKED BLOCK], low-angle power pose at high intensity, identity collapse, face no longer matches reference, plastic skin, broken or softened features under intensity`

### F3. Hand + body contact at intensity (cross-check with Stage 2)
**WIN**  
`[LOCKED BLOCK], hand in natural contact with body at high intensity, correct five-finger articulation, exact face identity preserved, realistic skin deformation and oil at contact, no interpenetration, fine art study, strong negative fill`

**LOSE**  
`[LOCKED BLOCK], hand melting into body, identity drift on the face, plastic skin under contact, fused anatomy, intensity caused face and skin failure`

---

## G. Fabric–skin interaction

### G1. Draped fabric on oiled skin
**WIN**  
`[LOCKED BLOCK], fabric draped over oiled skin with realistic pressure and micro-folds, skin pores and oil sheen still visible at contact edges, natural cloth tension, professional boudoir, soft dramatic light`

**LOSE**  
`[LOCKED BLOCK], fabric fused into the skin, plastic skin under cloth, no pore detail at contact, floating or interpenetrating fabric, flat lighting`

### G2. Minimal drape / implied
**WIN**  
`[LOCKED BLOCK], minimal fabric drape with correct skin–cloth boundary, visible pores and oil on exposed skin, believable weight and fold, fine art male study, cinematic lighting`

**LOSE**  
`[LOCKED BLOCK], fabric cutting into plastic skin, melted boundary, lost skin texture under drape, unrealistic cloth physics`

---

## Caption rules (Stage 3)

1. WIN always includes the locked block + explicit physics language (pores, oil breakup, SSS, internal glow, identity preserved under intensity).
2. LOSE names the physics/identity failure: wiped pores, painted sheen, chalky skin, identity collapse, plastic under oil.
3. Prefer real production failures (especially ones that only appear under heavy oil or close spicy crops) as LOSE images.
4. Tag these **Hard**. Do not mix Stage 2 anatomy defects here unless they co-occur with skin/identity failure.
5. Keep some Stage 2 anatomy language in WIN captions so Stage 2 gains are not forgotten.

**Volume target Stage 3:** 100–200 high-quality hard pairs (mix of D/E/F/G).

---

## Train order reminder

```
Stage 1 Easy framing        → checkpoint
Stage 2 Medium anatomy      → checkpoint   (templates: curriculum-dpo-stage2-templates.md)
Stage 3 Hard skin/oil/SSS   → final DPO LoRA  (this file)
→ DARE-TIES merge anatomy+skin LoRA @ 0.6–0.8
→ holdout_test eval
```

## Cross-references

- Parent: `curriculum-dpo-nsfw.md`
- Stage 2: `curriculum-dpo-stage2-templates.md`
- Pair scoring: `automated-pair-scoring.md`
- Runtime recovery: `spicy-male-erotic-prompt-optimizer` Error Handling
- Merge: `covicea-face-lock` + spicy `advanced-techniques.md`
- Helper script: `skill-orchestrator/scripts/scaffold_dpo_pairs.py`
