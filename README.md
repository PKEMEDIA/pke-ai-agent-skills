# PKE AI Agent Skills — Full Ecosystem

Official **Pretty Kitty Media / PKE Films** multi-agent skill pack for:

- Grok **iOS** · **web** · **Imagine** (user-driven) · **Build**
- **Free tier** autonomous learning (zero Imagine burn)
- **GitHub** connectors · **GitHub Actions CI** · **Notion** Empire OS · **Local ComfyUI**

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

## Podcast production (PERMANENT · 2026-08-01)

| Skill | Role |
| --- | --- |
| [`covicea-pke-podcast-studio`](./covicea-pke-podcast-studio/) | Full multi-agent studio: writers, journalists, fact-checkers, co-host, panels, SocialATS · Magentic hybrid orchestration · Episode Bible · spicy · continuous recall · **permanent activation** |

**Activate:** `Activate PKE Podcast Studio` · Deploy: [`docs/PODCAST-STUDIO-DEPLOY.md`](./docs/PODCAST-STUDIO-DEPLOY.md) · Automation: [`docs/GITHUB-AUTOMATION.md`](./docs/GITHUB-AUTOMATION.md)

## GitHub automation (ENABLED)

| Workflow | File | Purpose |
| --- | --- | --- |
| PKE Skill CI | [`.github/workflows/pke-skill-ci.yml`](./.github/workflows/pke-skill-ci.yml) | Validate all skills on push/PR |
| PKE Podcast Studio | [`.github/workflows/pke-podcast-studio.yml`](./.github/workflows/pke-podcast-studio.yml) | Studio DNA + permanent enable gates |
| CI script | [`scripts/ci-validate-skills.sh`](./scripts/ci-validate-skills.sh) | Repo-native validator |
| Permanent registry | [`config/permanent-activation.json`](./config/permanent-activation.json) | Online forever stamp |

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
   - `covicea-pke-podcast-studio/SKILL.md` (podcast — permanent)
   - `pke-synthetic-intellect/SKILL.md` (optional autonomy)
3. Attach face refs when generating: company face stills (`IMG_4440`, `IMG_4441`, `IMG_4450`) and mask ref when needed.
4. Triggers (examples): `skill-orchestrator`, `self heal`, `Activate PKE Podcast Studio`, `PKE PRESENTS`, face-lock / mask keywords.

### 3. Grok Build (Brand Guidelines app)

In a Build workspace that mirrors this pack:

```bash
sh startup.sh
# or
npm run dev   # binds 0.0.0.0:8080
```

### 4. Autonomous ops (free tier — local only)

```bash
bash scripts/ci-validate-skills.sh
bash scripts/pke-self-heal.sh
bash scripts/pke-self-heal.sh --push
bash scripts/pke-learn.sh
bash scripts/pke-learn.sh --push
bash covicea-pke-podcast-studio/scripts/validate-local.sh
```

### 5. Local ComfyUI

Load [`comfyui/pke-face-lock-base.json`](./comfyui/pke-face-lock-base.json).

### 6. Post-deploy health gates

| Gate | Pass |
| --- | --- |
| Self-heal | `STATUS=HEALTHY` exit 0 |
| Validate | All `SKILL.md` pass `validate-skill.sh` / CI |
| Podcast studio | `validate-local.sh` OK + permanent stamp |
| GitHub Actions | PKE Skill CI green on main |
| Learn | `imagine_calls=0` |

Full checklist: [`docs/FINALIZE.md`](./docs/FINALIZE.md)

---

## Gen order (every production still)

1. **pke-face-lock** identity  
2. If mask → **pke-official-black-mask**  
3. Title seal only — **PKE PRESENTS** or **A PKE PRODUCTION**  
4. Negatives — plastic skin, chrome spikes, sweat when dry, underage  

## Hard locks

1. One company face  
2. Pure-black mask (no chrome / recolor)  
3. No Imagine inside learn/heal loops  
4. Brand-safe casting only  
5. Podcast tea/conspiracy uses **allegedly** + FactChecker gate  

## Memory (synthetic intellect)

- [`mind/state.json`](./mind/state.json)  
- [`mind/lessons.md`](./mind/lessons.md)  
- [`config/permanent-activation.json`](./config/permanent-activation.json)  

## Deploy stamp

**FINALIZED** — production ready · healthy · **podcast studio PERMANENT** · **GitHub Actions ENABLED** — 2026-08-01
