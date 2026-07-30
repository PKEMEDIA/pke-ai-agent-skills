# PKE AI Agent Skills — Full Ecosystem

Official **Pretty Kitty Media / PKE Films** multi-agent skill pack for:

- Grok **iOS** · **web** · **Imagine** (user-driven) · **Build**
- **Free tier** autonomous learning (zero Imagine burn)
- **GitHub** connectors · **Local ComfyUI**

## Brand locks

| Skill | Role |
| --- | --- |
| [`pke-face-lock`](./pke-face-lock/) | Company face (freckles, copper braids, green-hazel) |
| [`pke-official-black-mask`](./pke-official-black-mask/) | Pure-black spiked leather mask |

## Meta agents

| Skill | Role |
| --- | --- |
| [`skill-orchestrator`](./skill-orchestrator/) | Health, self-heal, export, deploy |
| [`pke-synthetic-intellect`](./pke-synthetic-intellect/) | Always-learning free-tier mind |
| [`skill-creator`](./skill-creator/) | Validate / scaffold |

---

## Deployment

### 1. Clone the pack

```bash
git clone https://github.com/PKEMEDIA/pke-ai-agent-skills.git
cd pke-ai-agent-skills
```

### 2. Grok iOS / web (chat skills)

1. Open **Grok** (iOS app or web).
2. Install or paste skill bodies from:
   - `pke-face-lock/SKILL.md`
   - `pke-official-black-mask/SKILL.md`
   - `skill-orchestrator/SKILL.md`
   - `pke-synthetic-intellect/SKILL.md` (optional autonomy)
3. Attach face refs when generating: company face stills (`IMG_4440`, `IMG_4441`, `IMG_4450`) and mask ref when needed.
4. Triggers (examples): `skill-orchestrator`, `self heal`, `PKE PRESENTS`, face-lock / mask keywords.

### 3. Grok Build (Brand Guidelines app)

In a Build workspace that mirrors this pack:

```bash
# Idempotent start — required for preview revive
sh startup.sh
# or
npm run dev   # binds 0.0.0.0:8080
```

- Preview auto-discovers the app on port **8080**.
- Keep `startup.sh` in repo root so hibernate/revive restores the server.
- Production check: `npm run build` && `npm run typecheck` (Vercel target).

### 4. Autonomous ops (free tier — local only)

```bash
# Health: detect → repair → re-validate
bash scripts/pke-self-heal.sh
bash scripts/pke-self-heal.sh --push   # also sync brand pack to this repo

# Synthetic intellect: heal → observe → score → improve → remember
bash scripts/pke-learn.sh
bash scripts/pke-learn.sh --push       # + push mind + skill patches
```

| Script | Path |
| --- | --- |
| Self-heal | [`scripts/pke-self-heal.sh`](./scripts/pke-self-heal.sh) (mirrored under `skill-orchestrator/scripts/`) |
| Learn | [`scripts/pke-learn.sh`](./scripts/pke-learn.sh) |

Requirements: `bash`, `python3`, optional `gh` auth for `--push`.  
**Never** calls Imagine/video — safe on free tier forever.

### 5. Local ComfyUI

1. Install [ComfyUI](https://github.com/comfyanonymous/ComfyUI) + custom nodes (IP-Adapter FaceID / InstantID, ControlNet OpenPose, Impact FaceDetailer as needed).
2. Drop models into the folders your graph expects.
3. Load [`comfyui/pke-face-lock-base.json`](./comfyui/pke-face-lock-base.json).
4. Point FaceID to locked face ref; use OpenPose only for pose layout.
5. Save variants for mask / title-card stills (swap text + crop only).

See [`comfyui/README-pke-face-lock-base.md`](./comfyui/README-pke-face-lock-base.md) if present.

### 6. GitHub connector (export / sync)

**Export set (brand-safe text only):**

- `pke-face-lock/SKILL.md`
- `pke-official-black-mask/SKILL.md`
- `skill-orchestrator/SKILL.md` + `references/pke-brand-map.md`
- `skill-orchestrator/scripts/pke-self-heal.sh` + `pke-learn.sh`
- `scripts/pke-self-heal.sh` + `pke-learn.sh`
- `comfyui/pke-face-lock-base.json`
- `README.md`

**Recovery after push lock:**

```bash
bash scripts/pke-self-heal.sh --push
# or: tree re-read → missing-only push → max 2 attempts
```

### 7. Post-deploy health gates

| Gate | Pass |
| --- | --- |
| Self-heal | `STATUS=HEALTHY` exit 0 |
| Validate | All `SKILL.md` pass `validate-skill.sh` |
| Face assets | Present where the Build workspace expects them |
| Comfy JSON | Loads without missing-node errors |
| Brand app | HTTP 200 + visible content |
| Learn | `imagine_calls=0` |

Full checklist: [`docs/FINALIZE.md`](./docs/FINALIZE.md)

---

## Gen order (every production still)

1. **pke-face-lock** identity  
2. If mask → **pke-official-black-mask**  
3. Title seal only — **PKE PRESENTS** or **A PKE PRODUCTION**  
4. Negatives — plastic skin, chrome spikes, sweat when dry, underage  

## Title seals

- **PKE PRESENTS**
- **A PKE PRODUCTION**

## Hard locks

1. One company face  
2. Pure-black mask (no chrome / recolor)  
3. No Imagine inside learn/heal loops  
4. Brand-safe casting only  

## FaceID vs OpenPose

| Adapter | Role |
| --- | --- |
| FaceID / InstantID | WHO — identity from face refs |
| OpenPose | WHERE — skeleton / pose |

## Memory (synthetic intellect)

- [`mind/state.json`](./mind/state.json)  
- [`mind/lessons.md`](./mind/lessons.md)  

## Deploy stamp

**FINALIZED** — production ready · healthy · learn push hardened — 2026-07-30
