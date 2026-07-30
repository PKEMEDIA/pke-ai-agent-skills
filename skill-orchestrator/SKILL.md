---
name: skill-orchestrator
description: Orchestrate validate link and deploy PKE Pretty Kitty Media skills for Grok iOS web Imagine Build and GitHub connectors. Triggers on skill orchestrator, orchestrate skills, finalize skills, deploy skills, PKE skill map, lock skills, validate skill ecosystem, run skill health check, GitHub export, finish export, push lock, clean up skills.
metadata:
  short-description: Orchestrate PKE skills for iOS web connectors
  platforms: grok-ios, grok-web, grok-imagine, grok-build, github-connector
  version: "1.2.0"
---

# Skill Orchestrator (PKE scope)

Meta-skill for Pretty Kitty Media / PKE Films. Validates skills, Brand Guidelines app, Comfy local pack, and GitHub export. Works the same when the user is on **Grok iOS** or **web**.

## PKE skill map

| Skill | Role |
|---|---|
| `pke-face-lock` | Official company face |
| `pke-official-black-mask` | Pure-black spiked leather mask |
| `skill-orchestrator` | This meta-skill |
| `skill-creator` | Frontmatter validate / scaffold |
| `skill-test-suite` | Full structural harness |

## Ecosystems / connectors

| Ecosystem | Deploy target | Notes |
|---|---|---|
| Grok iOS | Skills load via description triggers | Short triggers; attach refs in chat |
| Grok web | Same skill pack | Preview + Imagine side by side |
| Grok Imagine | Prompt blocks from face + mask skills | Mild base → edit; quota-aware |
| Grok Build | Brand Guidelines app + assets | Serve on preview; `startup.sh` |
| GitHub | `PKEMEDIA/pke-ai-agent-skills` | Brand-safe text only |
| Local ComfyUI | `artifacts/comfyui/pke-face-lock-base.json` | FaceID + OpenPose; zero cloud burn |

## Default generation order

1. **pke-face-lock** identity block
2. If mask required → **pke-official-black-mask**
3. Title tokens only - **PKE PRESENTS** / **A PKE PRODUCTION**
4. Negatives - plastic skin, chrome spikes, sweat when dry, underage

## FaceID vs OpenPose

| Adapter | Role | Strength |
|---|---|---|
| FaceID / InstantID | WHO — identity | 0.75–0.90 |
| OpenPose | WHERE — skeleton | 0.80–1.0 |

## Health check protocol

| Gate | Pass |
|---|---|
| Brand skills present | face-lock, black-mask, orchestrator |
| Validate | `validate-skill.sh` OK on all workspace skills |
| Face assets | `public/pke/IMG_4440.jpg` `IMG_4441.jpg` `IMG_4450.jpg` |
| Casting deck | `artifacts/PKE-Face-Lock-Casting-Package.pptx` |
| Comfy base | `artifacts/comfyui/pke-face-lock-base.json` |
| Brand app | HTTP 200, visible content, clean console |
| GitHub | Required export set on `main` |
| No junk | No `export-fix/*.b64` or push-args leftovers |

## GitHub export set

- `pke-face-lock/SKILL.md`
- `pke-official-black-mask/SKILL.md`
- `skill-orchestrator/SKILL.md`
- `skill-orchestrator/references/pke-brand-map.md`
- `comfyui/pke-face-lock-base.json` (optional companion)
- `README.md`

## Push-lock recovery

1. Tree re-read → 2. Diff missing → 3. Single missing-only push → 4. Verify → max 2 attempts

## Quality scoring (ship ≥ 8)

Freckles/eyes/braids 0–3 · Dry skin 0–2 · Mask pure black 0–2 · Title seal 0–2 · Clear space 0–1

## Hard stops

- No second company face
- No mask recolor
- No green stamp if any gate fails
- Brand-safe casting only
- No secrets in GitHub export

## Last orchestration stamp

- **Date:** 2026-07-30 00:03 EDT
- **Actions:** Validate all skills; iOS/web/connector platform notes; cleanup export-fix junk; ship Comfy base; GitHub deploy
- **Status:** PRODUCTION READY · VALIDATE GREEN · ECOSYSTEMS ALIGNED
