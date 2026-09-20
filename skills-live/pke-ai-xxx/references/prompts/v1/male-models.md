# Male AI Talent System — Create Male Models for PKE

**Purpose:** Build reusable **male** AI performers (character sheets → prompt tokens → optional LoRA) for MMF, solo, FemDom serve, group, POV.  
**Lock rule:** Do **not** train, reference, or approximate **Face Lock** or **Black Mask**. New faces only.

---

## Design principles

1. **Adult only** — clearly 25+ face/body read; no youthful soft-teen cues.  
2. **POC-forward default** — deep skin tones, textured hair, facial hair variety as first-class options, not afterthoughts.  
3. **Hung athletic as a product lane** — but ship a **roster** (not one body).  
4. **Trigger words** — short, unique, studio-owned: `pkemale01` … `pkemale99`.  
5. **Separable traits** — face LoRA vs body tokens so you can mix “face A + hung body.”

---

## Body-type palette (prompt tokens)

| ID | Label | Positive body tokens |
|----|-------|----------------------|
| B1 | Hung athletic | `athletic male body, defined abs, V-taper, broad shoulders, large thick erect penis, heavy balls, veiny shaft, proportional hung` |
| B2 | Hung muscular | `bodybuilder muscular male, thick chest, huge arms, narrow waist, massive erect cock, pornstar physique` |
| B3 | Slim hung | `slim fit male, lean torso, visible hips, long thick penis, low body fat` |
| B4 | Stocky / bull | `stocky powerful male, thick neck, barrel chest, strong thighs, fat thick cock` |
| B5 | Dadbod soft | `soft dad bod, hairy chest optional, natural belly, thick penis, approachable amateur` |
| B6 | Tall lanky hung | `very tall male, long limbs, lean muscle, large hanging cock` |

**Grooming add-ons:** `shaved pubes` · `trimmed bush` · `happy trail` · `full bush` · `chest hair` · `smooth` · `beard` · `mustache` · `clean shaven` · `durag` · `fade haircut` · `locs` · `short afro` · `waves`

---

## Face variety (no locked faces)

Build **distinct** adult male faces. Store a face sheet (front / 3/4 / profile / expression) per ID.

| Face lane | Tokens (examples) |
|-----------|-------------------|
| F-POC-A | `handsome adult Black man, deep brown skin, strong jaw, short beard, warm brown eyes, mid-30s` |
| F-POC-B | `handsome adult Black man, dark skin, clean fade, light mustache, intense eyes, late-20s adult` |
| F-POC-C | `adult Latino man, medium-deep skin, stubble, thick brows, soft smile, early-30s` |
| F-POC-D | `adult South Asian man, brown skin, neat beard, dark eyes, athletic face, 30s` |
| F-MIX-E | `adult mixed-race man, light-brown skin, curly hair, freckles optional, 30s` |
| F-WHITE-F | `adult white man, tanned skin, stubble, blue or green eyes, 30s` — use when cast needs contrast, not as default |

**Expression set for sheets:** neutral · smirk · open-mouth moan · tongue out · submissive eyes-up · dominant stare.

**Banned:** any instruction to recreate Face Lock / Black Mask; celebrity real-name likeness prompts for impersonation packs.

---

## Skin tones (POC-forward scale)

Use explicit tone tokens so models don’t default pale:

```
deep ebony skin, rich dark brown skin, dark chocolate skin,
medium brown skin, caramel brown skin, light brown skin,
olive skin, golden brown undertone, visible skin pores, natural melanin
```

Pair with lighting: `rim light on dark skin`, `melanin-friendly exposure`, `no washed-out faces`.

---

## Prompt token bundles (copy-paste)

### Male solo hero (still)

```
pkemale01, [FACE TOKENS], [BODY TOKENS], standing, full body character sheet,
nude male, explicit, studio soft light, adult man 30s, looking at camera
```

### Male in double-oral stack (with second male)

```
pkemale01 and pkemale02, two distinct adult male faces, side-by-side between thighs,
both looking up at camera, [BODY tokens each], hung, lace aside scene
```

### FemDom serve kneel

```
pkemale01, kneeling, submissive eye contact looking up, erect cock, hands behind back,
adult handsome man, [FACE], [BODY], Domme legs in foreground
```

---

## Character card template (YAML)

Save as `characters/pkemale01.yaml` (sidecar next to LoRA or in pack ops folder).

```yaml
id: pkemale01
studio: Pretty Kitty Entertainment / Coviceá
status: active
locks:
  face_lock: false
  black_mask: false
  note: "NEW face only — never train on Face Lock / Black Mask assets"

trigger: pkemale01
alt_triggers: ["pke_male_01"]

face:
  lane: F-POC-A
  age_read: "early 30s adult"
  skin: "deep brown skin"
  hair: "short fade"
  facial_hair: "short boxed beard"
  eyes: "dark brown"
  notes: "strong jaw, warm expression; distinct from pkemale02"

body:
  type: B1_hung_athletic
  height_read: "6ft / tall in frame"
  cock: "large thick erect, veiny, trimmed pubes"
  other: "defined abs, V-taper"

prompt_core: >-
  pkemale01, handsome adult Black man, early 30s, deep brown skin, short fade,
  short boxed beard, dark brown eyes, athletic male body, defined abs,
  large thick erect penis, trimmed pubes

negative_extra: >-
  teen, boyish, Face Lock, Black Mask, same face as pkemale02, feminine body

lora:
  file: "pkemale01.safetensors"   # after training
  suggested_weight: 0.75
  train_status: "planned"         # planned | training | ready | retired

seeds:
  hero_face: null                 # fill after you find a keeper still
  hero_body: null

sheet_paths:
  front: null
  three_quarter: null
  profile: null
  explicit_nude: null

usage:
  - double_oral_mmf
  - solo_male
  - femdom_serve
  - pov
```

Duplicate YAML per male; change `id`, face lane, and body type. Keep `pkemale02` **visually distant** from `01` (hair, beard, skin depth, nose/jaw).

---

## Roster starter (suggested first 4)

| ID | Face | Body | Role |
|----|------|------|------|
| pkemale01 | F-POC-A | B1 hung athletic | Default co-star / double-oral left |
| pkemale02 | F-POC-B | B1 or B2 | Double-oral right / contrast beard-hair |
| pkemale03 | F-POC-C | B4 bull | FemDom serve / rough energy |
| pkemale04 | F-MIX-E | B3 slim hung | POV / amateur heat |

---

## Consistency stack (without Face Lock)

1. Character sheet stills (fixed seed + IP-Adapter self-ref).  
2. Optional **FaceID / IP-Adapter Face** on **your** sheet images only.  
3. Optional LoRA trained on **your** sheet + angled gens (`comfyui/male-lora-training.md`).  
4. Never point FaceID at locked-face archives.

---

## QC before a male enters production

- [ ] Reads 25+ adult  
- [ ] Not confusable with Face Lock / Black Mask / existing `pkemale##`  
- [ ] Hands/genitals acceptable on hero nudes  
- [ ] YAML filled + trigger documented  
- [ ] POC skin holds under Teaser lighting  
