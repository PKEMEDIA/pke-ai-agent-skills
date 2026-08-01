# PKE Brand Map

## Platforms

Grok iOS · Grok web · Imagine · Build · GitHub connector · GitHub Actions CI · Local ComfyUI

## Gen order

1. Load **pke-face-lock** (freckles, copper braids, green-hazel eyes, dry skin)
2. If mask required → **pke-official-black-mask** (pure black dense pyramid spikes, full-grain leather)
3. Title / motion tokens only - **PKE PRESENTS** or **A PKE PRODUCTION**
4. Negatives - plastic skin, chrome spikes, sweat/water when dry, underage

## FaceID vs OpenPose

| Adapter | Role |
|---|---|
| FaceID | WHO — identity from face refs |
| OpenPose | WHERE — limb layout from pose ref |

## Quality rubric (0–10, ship ≥ 8)

| Criterion | Points |
|---|---|
| Freckles + green-hazel + copper braids | 0–3 |
| Dry natural skin | 0–2 |
| Mask pure black dense spikes (no chrome) | 0–2 |
| Title hierarchy single seal line | 0–2 |
| Composition / clear space | 0–1 |

## Podcast / voice brand (permanent)

| Item | Spec |
|---|---|
| Host | Coviceá — Aloha Shade Ohana |
| Shows | The 3-2 Podcast · The Siren Soul · THE WHAT IF FILES |
| Studio skill | **covicea-pke-podcast-studio** (permanent · spicy) |
| Claim rule | **allegedly** + FactChecker on tea/conspiracy |
| Growth | SocialATSEnhancer · clip-first · queer POC sex-positive niche |

## Assets

| Asset | Path |
|---|---|
| Face ¾ | `public/pke/IMG_4440.jpg` |
| Face front | `public/pke/IMG_4441.jpg` |
| Face window | `public/pke/IMG_4450.jpg` |
| Casting deck | `artifacts/PKE-Face-Lock-Casting-Package.pptx` |
| Comfy workflow | `artifacts/comfyui/pke-face-lock-base.json` |

## GitHub export set

- `pke-face-lock/SKILL.md`
- `pke-official-black-mask/SKILL.md`
- `skill-orchestrator/SKILL.md`
- `skill-orchestrator/references/pke-brand-map.md`
- `covicea-pke-podcast-studio/SKILL.md`
- `config/permanent-activation.json`
- `comfyui/pke-face-lock-base.json`
- `README.md`
- `.github/workflows/pke-skill-ci.yml`
- `.github/workflows/pke-podcast-studio.yml`

## Recovery

Push lock → tree re-read → missing-only push (max 2) → verify tree → Actions green.

## Self-heal

```bash
bash scripts/pke-self-heal.sh
bash scripts/pke-self-heal.sh --push
bash scripts/ci-validate-skills.sh
```

Logs: `artifacts/heal-logs/heal-*.log`
