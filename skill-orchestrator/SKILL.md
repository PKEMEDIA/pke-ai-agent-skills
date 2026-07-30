---
name: skill-orchestrator
description: Orchestrate, validate, and link PKE / Pretty Kitty Media skills with the brand guidelines app and GitHub export. Triggers on skill orchestrator, orchestrate skills, finalize skills, deploy skills, PKE skill map, lock skills, validate skill ecosystem, run skill health check, GitHub export, finish export, push lock.
metadata:
  short-description: Orchestrate and validate PKE brand skill ecosystem
---

# Skill Orchestrator (PKE scope)

Meta-skill for the Pretty Kitty Media / PKE Films brand ecosystem. Validates skills, assets, the live Brand Guidelines app, and GitHub skill-pack export. Permanent production scope.

## PKE skill map

| Skill | Role | Path |
|---|---|---|
| `pke-face-lock` | Official company face identity | `.grok/skills/pke-face-lock/` |
| `pke-official-black-mask` | Pure-black spiked leather mask lock | `.grok/skills/pke-official-black-mask/` |
| `design-ui` | Brand guidelines UI chrome | `.grok/skills/design-ui/` |
| `imagine` | Image prompt craft | `.grok/skills/imagine/` |
| `skill-orchestrator` | This meta-skill | `.grok/skills/skill-orchestrator/` |

## GitHub export target

| Item | Value |
|---|---|
| Owner | `PKEMEDIA` |
| Repo | `pke-ai-agent-skills` |
| Branch | `main` |
| Brand locks | `pke-face-lock/`, `pke-official-black-mask/`, `skill-orchestrator/references/pke-brand-map.md` |

## Default generation order

1. Load **pke-face-lock** identity block (freckles, copper braids, green-hazel eyes)
2. If mask required → load **pke-official-black-mask** block (pure black dense spikes)
3. Apply title / motion tokens: **PKE PRESENTS** / **A PKE PRODUCTION**
4. Negatives: plastic skin, chrome spikes, sweat/water when dry requested, underage

## Health check protocol (run on invoke)

| Gate | Pass criteria |
|---|---|
| Skills present | `pke-face-lock`, `pke-official-black-mask`, `skill-orchestrator` exist |
| Face assets | `/workspace/public/pke/IMG_4440.jpg`, `IMG_4441.jpg`, `IMG_4450.jpg` present |
| Casting deck | `/workspace/artifacts/PKE-Face-Lock-Casting-Package.pptx` present |
| Brand app | Live preview serves Brand Guidelines with Face Lock section |
| Console clean | Browser smoke: no uncaught errors, visible content |
| Title hierarchy | App + skills lock PKE PRESENTS / A PKE PRODUCTION only |
| GitHub brand locks | Tree contains face-lock + black-mask + brand-map |
| Structural validate | `validate-skill.sh` OK on brand skills |

## GitHub push-lock recovery (parallel agent fix)

When `github___push_files` is rejected as “another agent already completed” or duplicate:

1. **Re-read tree** — recursive on `PKEMEDIA/pke-ai-agent-skills`
2. **Diff** — list paths missing vs intended export set
3. **Single-writer commit** — one `push_files` with only missing brand-safe files + unique timestamped commit message
4. **Verify** — re-fetch tree; stamp green only if all required paths exist
5. **Do not loop** — max 2 push attempts per turn after tree re-read

Required export set (brand-safe):

- `pke-face-lock/SKILL.md`
- `pke-official-black-mask/SKILL.md`
- `skill-orchestrator/SKILL.md`
- `skill-orchestrator/references/pke-brand-map.md`
- `README.md`

## Quality scoring (0–10)

| Criterion | Points |
|---|---|
| Freckles + green-hazel eyes + copper braids match | 0–3 |
| Dry natural skin (no plastic, no sweat if dry) | 0–2 |
| Mask pure black dense spikes when worn (no chrome) | 0–2 |
| Title hierarchy correct (single seal line) | 0–2 |
| Composition / clear space | 0–1 |

**Ship threshold:** ≥ 8.

## Failure classes & recovery

| Class | Detect | Recovery |
|---|---|---|
| Face lock miss | Wrong eyes, missing freckles, braid color drift | Re-insert full face lock block |
| Mask fail | Chrome spikes, patent plastic, sparse spikes | Re-insert pure-black mask block |
| Title clutter | Redundant studio name under PRESENTS | Strip to single seal line |
| Asset missing | 404 on public/pke refs | Restore face refs to public/pke |
| App blank / console error | Smoke test fail | Fix routes; re-run browser smoke |
| GitHub push lock | Parallel agent / duplicate rejection | Tree re-read → missing-only push → verify |
| Validate fail | angle brackets or bad frontmatter | skill-creator rewrite plain scalar description |

## Hard stops

- Do not invent a second company face
- Do not recolor the official mask
- Do not claim health green if any gate fails
- Brand-safe casting only
- Do not claim GitHub export complete if required paths missing

## Deliverables

- Live Brand Guidelines app (preview)
- Face lock skill + mask skill
- Casting deck PPTX under `/workspace/artifacts/`
- GitHub: [PKEMEDIA/pke-ai-agent-skills](https://github.com/PKEMEDIA/pke-ai-agent-skills)
- This orchestrator health stamp

## Last orchestration stamp

- **Date:** 2026-07-29 23:48 EDT — skill-creator validate fix + health re-run
- **Actions:** Plain-scalar frontmatter on face-lock + black-mask; restored `references/pke-brand-map.md`; browser smoke green
- **GitHub:** push brand-safe skill pack after validate
- **Local:** Brand Guidelines live · assets OK · console clean
- **Status:** PRODUCTION READY · VALIDATE GREEN
