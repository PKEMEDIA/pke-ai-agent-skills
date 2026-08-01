# PKE Full Ecosystem Map

## Surfaces

| Surface | Integration |
|---|---|
| Grok iOS | Skill triggers from chat; attach face/mask refs; podcast studio |
| Grok web | Same skills + Brand Guidelines preview |
| Grok Imagine | User-driven only; mild base → edit; locks from face/mask skills |
| Grok Build | **Aleah Empire OS** live control plane + scripts |
| GitHub | `PKEMEDIA/pke-ai-agent-skills` · Actions CI · `comfyui` · `SentientEmpireOffice` |
| Free tier | `pke-learn.sh` / `pke-self-heal.sh` / Aleah mind — zero Imagine |
| Local ComfyUI | `comfyui/pke-face-lock-base.json` FaceID + OpenPose + offline-sim |

## Agents (skills)

| Skill | Class | Role |
|---|---|---|
| **aleah-empire-os** | Meta OS | Permanent control plane |
| pke-face-lock | Brand lock | Company face |
| pke-official-black-mask | Brand lock | Official mask |
| skill-orchestrator | Meta | Health, heal, export |
| pke-synthetic-intellect | Meta | Autonomous learn (Aleah mind) |
| skill-creator | Meta | Validate / scaffold |
| **covicea-pke-podcast-studio** | Production | **PERMANENT** multi-agent podcast studio |
| pke-empire-os | Ops | Empire strategy |
| design-ui / imagine / … | App Builder | Product surfaces |

## GitHub automation

| Workflow | Trigger | Gate |
|---|---|---|
| `pke-skill-ci.yml` | push/PR/dispatch | All SKILL.md + brand pack + permanent stamp |
| `pke-podcast-studio.yml` | studio paths / dispatch | DNA · agents · permanent enable |

Config: `config/permanent-activation.json` · Docs: `docs/GITHUB-AUTOMATION.md`

## Deploy order

1. Validate all skills (`ci-validate-skills.sh` / `validate-skill.sh`)
2. Self-heal
3. Learn cycle
4. Brand app / Aleah smoke
5. Comfy graph offline-sim
6. GitHub push brand pack + mind + scripts + ecosystem map + Actions
7. Confirm Actions green + permanent-activation.json

## Commands

```bash
bash scripts/ci-validate-skills.sh
bash scripts/pke-self-heal.sh
bash scripts/pke-learn.sh
bash scripts/pke-learn.sh --push
bash covicea-pke-podcast-studio/scripts/validate-local.sh
node scripts/aleah-validate.mjs
python3 scripts/comfy-offline-sim.py
```
