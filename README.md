# PKE AI Agent Skills

Official Pretty Kitty Media / PKE Films skill pack for **Grok iOS**, **Grok web**, Imagine, Build, and GitHub connectors.

## Skills

| Skill | Purpose |
| --- | --- |
| `pke-face-lock` | Locked company face (freckles, copper braids, green-hazel eyes) |
| `pke-official-black-mask` | Locked pure-black spiked leather bunny mask |
| `skill-orchestrator` | Health checks, export, recovery, platform map |

## Platforms

- Grok iOS / web chat — skills trigger from short brand phrases
- Grok Imagine — use prompt blocks; mild base → edit
- Grok Build — Brand Guidelines app + `public/pke/` refs
- Local ComfyUI — see `comfyui/pke-face-lock-base.json` (FaceID + OpenPose)

## Gen order

1. Face lock → 2. Mask if needed → 3. **PKE PRESENTS** / **A PKE PRODUCTION** → 4. Negatives

## Title seals only

- **PKE PRESENTS** (openers)
- **A PKE PRODUCTION** (end cards)

## Quality

Ship threshold ≥ 8/10 (face match, dry skin, pure-black mask, title seal, clear space).

## Repo layout

```
pke-face-lock/SKILL.md
pke-official-black-mask/SKILL.md
skill-orchestrator/SKILL.md
skill-orchestrator/references/pke-brand-map.md
comfyui/pke-face-lock-base.json
README.md
```

## License / use

Brand-internal. Do not invent a second company face or recolor the official mask.
