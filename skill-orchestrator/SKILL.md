---
name: skill-orchestrator
description: Orchestrate validate heal link and deploy PKE Pretty Kitty Media skills for Grok iOS web Imagine Build and GitHub connectors. Triggers on skill orchestrator, orchestrate skills, finalize skills, deploy skills, self heal, self-healing, PKE skill map, lock skills, validate skill ecosystem, run skill health check, GitHub export, finish export, push lock, clean up skills.
metadata:
  short-description: Orchestrate heal and deploy PKE skills
  platforms: grok-ios, grok-web, grok-imagine, grok-build, github-connector
  version: "1.3.0"
---

# Skill Orchestrator (PKE scope)

Meta-skill for Pretty Kitty Media / PKE Films. Validates, **self-heals**, deploys Brand Guidelines app, Comfy local pack, and GitHub export. Same on **Grok iOS** and **web**.

## PKE skill map

| Skill | Role |
|---|---|
| `pke-face-lock` | Official company face |
| `pke-official-black-mask` | Pure-black spiked leather mask |
| `skill-orchestrator` | This meta-skill |
| `skill-creator` | Frontmatter validate / scaffold |
| `skill-test-suite` | Full structural harness |

## Self-healing (run first on any failure)

**Command:**

```bash
bash /workspace/scripts/pke-self-heal.sh          # local heal
bash /workspace/scripts/pke-self-heal.sh --push   # heal + GitHub sync
```

Also shipped at `skill-orchestrator/scripts/pke-self-heal.sh`.

### Auto-repairs

| Failure | Heal action |
|---|---|
| Skill validate fail (folded `description: >`, angle brackets, colon-space) | Rewrite plain scalar description |
| Missing `pke-brand-map.md` | Restore canonical brand-map |
| App down on :8080 | Run `startup.sh` (recreate if missing) |
| Junk `export-fix/*.b64` / push-args | Delete |
| Missing Comfy base but staging exists | Copy from `artifacts/github-export/` |
| GitHub drift (`--push`) | Clone → copy brand pack → commit → push |

### Self-heal loop (agent protocol)

1. Run `pke-self-heal.sh`
2. If `STATUS=HEALTHY` → stamp green
3. If `STATUS=DEGRADED` → read heal log under `artifacts/heal-logs/` → manual fix remaining MISS assets → re-run
4. Max 2 auto-heal passes per turn; never loop forever
5. Binary face refs (`public/pke/IMG_*.jpg`) cannot be invented — restore from backup or user

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
| Self-heal | `pke-self-heal.sh` exits 0 (HEALTHY) |

## GitHub export set

- `pke-face-lock/SKILL.md`
- `pke-official-black-mask/SKILL.md`
- `skill-orchestrator/SKILL.md`
- `skill-orchestrator/references/pke-brand-map.md`
- `skill-orchestrator/scripts/pke-self-heal.sh`
- `comfyui/pke-face-lock-base.json`
- `README.md`

## Push-lock recovery

1. Tree re-read → 2. Diff missing → 3. Single missing-only push → 4. Verify → max 2 attempts  
Or run `bash scripts/pke-self-heal.sh --push`.

## Quality scoring (ship ≥ 8)

Freckles/eyes/braids 0–3 · Dry skin 0–2 · Mask pure black 0–2 · Title seal 0–2 · Clear space 0–1

## Hard stops

- No second company face
- No mask recolor
- No green stamp if any gate fails
- Brand-safe casting only
- No secrets in GitHub export

## Synthetic Intellect (autonomous · free-tier)

```bash
bash /workspace/scripts/pke-learn.sh          # observe → heal → improve → stamp
bash /workspace/scripts/pke-learn.sh --push   # + sync improvements to GitHub
```

- Runs **locally only** — no Imagine, no video, no SuperGrok burn.
- Learns from heal logs, validate fails, asset gates, and skill text gaps.
- Writes lessons to `artifacts/pke-mind/` and may patch skill docs.
- Always self-heal before applying improvements.
- Safe on free tier forever; cloud gen is optional user action only.

## Last orchestration stamp

- **Date:** 2026-07-30 00:09 EDT
- **Actions:** Self-heal harness installed; first run HEALTHY 19/19; no repairs needed
- **Status:** PRODUCTION READY · SELF-HEAL GREEN · VALIDATE GREEN
