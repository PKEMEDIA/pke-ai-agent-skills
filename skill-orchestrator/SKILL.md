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

## GitHub push-lock recovery (parallel agent fix)

When `github___push_files` is rejected as "another agent already completed" or duplicate:

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

Ship threshold ≥ 8. Face match 0–3, dry skin 0–2, mask pure black 0–2, title hierarchy 0–2, composition 0–1.

## Hard stops

- Do not invent a second company face
- Do not recolor the official mask
- Do not claim health green if any gate fails
- Brand-safe casting only
- Do not claim GitHub export complete if required paths missing

## Last orchestration stamp

- **Date:** 2026-07-29 23:23 EDT — export lock recovery
- **Status:** PRODUCTION · export recovery applied
