---
name: skill-orchestrator
description: Orchestrate validate heal link and deploy PKE Pretty Kitty Media skills for Grok iOS web Imagine Build and GitHub connectors. Triggers on skill orchestrator, orchestrate skills, finalize skills, deploy skills, self heal, self-healing, distributed consensus, quorum heal, PKE skill map, lock skills, validate skill ecosystem, run skill health check, GitHub export, finish export, push lock, clean up skills.
metadata:
  short-description: Orchestrate heal and deploy PKE skills
  platforms: grok-ios, grok-web, grok-imagine, grok-build, github-connector
  version: "1.5.0"
---

# Skill Orchestrator (PKE scope)

Meta-skill for Pretty Kitty Media / PKE Films. Validates, **self-heals with distributed consensus**, deploys Brand Guidelines app, Comfy local pack, and GitHub export. Same on **Grok iOS** and **web**.

## PKE skill map

| Skill | Role |
|---|---|
| `pke-face-lock` | Official company face |
| `pke-official-black-mask` | Pure-black spiked leather mask |
| `skill-orchestrator` | This meta-skill |
| `skill-creator` | Frontmatter validate / scaffold |
| `skill-test-suite` | Full structural harness |

## Distributed consensus self-heal (v1.5)

Prevents split-brain when multiple healers race the same target.

```bash
node scripts/consensus-self-heal.mjs          # unit suite + demo (6/6)
node scripts/consensus-self-heal.mjs --json
bash scripts/heal-lease.sh acquire <target> <holder> [ttl]
bash scripts/heal-lease.sh release <target> <holder>
```

Phases: **PROBE → PROPOSE → VOTE → LEASE → COMMIT → VERIFY → RELEASE**  
Quorum: majority of voters (default 5 → 3 ACK). Protocol: `skill-orchestrator/references/distributed-consensus-self-heal.md`.

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
| Multi-healer race | Consensus quorum + exclusive lease |

### Self-heal loop (agent protocol)

1. Run consensus gate when multiple workers may heal (`consensus-self-heal.mjs` or `heal-lease.sh`)
2. Run `pke-self-heal.sh`
3. If `STATUS=HEALTHY` → stamp green
4. If `STATUS=DEGRADED` → read heal log under `artifacts/heal-logs/` → manual fix remaining MISS assets → re-run
5. Max 2 auto-heal passes per turn; never loop forever
6. Binary face refs (`public/pke/IMG_*.jpg`) cannot be invented — restore from backup or user

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
|---|---|---|
| Brand skills present | face-lock, black-mask, orchestrator |
| Validate | `validate-skill.sh` OK on all workspace skills |
| Face assets | `public/pke/IMG_4440.jpg` `IMG_4441.jpg` `IMG_4450.jpg` |
| Casting deck | `artifacts/PKE-Face-Lock-Casting-Package.pptx` |
| Comfy base | `artifacts/comfyui/pke-face-lock-base.json` |
| Brand app | HTTP 200, visible content, clean console |
| GitHub | Required export set on `main` |
| No junk | No `export-fix/*.b64` or push-args leftovers |
| Self-heal | `pke-self-heal.sh` exits 0 (HEALTHY) |
| Consensus | `consensus-self-heal.mjs` 6/6 unit tests |

## GitHub export set

- `pke-face-lock/SKILL.md`
- `pke-official-black-mask/SKILL.md`
- `skill-orchestrator/SKILL.md`
- `skill-orchestrator/references/pke-brand-map.md`
- `skill-orchestrator/references/distributed-consensus-self-heal.md`
- `skill-orchestrator/scripts/pke-self-heal.sh`
- `skill-orchestrator/scripts/consensus-self-heal.mjs`
- `skill-orchestrator/scripts/heal-lease.sh`
- `scripts/consensus-self-heal.mjs`
- `scripts/heal-lease.sh`
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

- **Date:** 2026-07-30 00:37 EDT
- **Actions:** Distributed consensus self-heal (quorum + exclusive lease); engine 6/6 tests; lease helper for Mac Pro multi-process
- **Status:** PRODUCTION READY · CONSENSUS SELF-HEAL LIVE · ECOSYSTEM INTEGRATED

## PKE agent ecosystem (always load)

| Agent / skill | When |
|---|---|
| `pke-face-lock` | Company face / casting / roster |
| `pke-official-black-mask` | Mask / title stills |
| `skill-orchestrator` | Health, export, self-heal, consensus, deploy |
| `pke-synthetic-intellect` | Free-tier autonomous learn cycle |
| `skill-creator` | Validate after any SKILL.md edit |

**Autonomous ops (local, free tier):**

```bash
bash /workspace/scripts/pke-self-heal.sh
node /workspace/scripts/consensus-self-heal.mjs
bash /workspace/scripts/pke-learn.sh
```

**Hard locks:** one company face · pure-black mask · title seals **PKE PRESENTS** / **A PKE PRODUCTION** only · no Imagine in learn loop.
