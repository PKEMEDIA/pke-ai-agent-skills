# PKE Full Ecosystem Map

## Surfaces

| Surface | Integration |
|---|---|
| Grok iOS | Skill triggers from chat; attach face/mask refs |
| Grok web | Same skills + Brand Guidelines preview |
| Grok Imagine | User-driven only; mild base → edit; locks from face/mask skills |
| Grok Build | **Aleah Empire OS** live control plane + scripts |
| GitHub | `PKEMEDIA/pke-ai-agent-skills` · `comfyui` · `SentientEmpireOffice` |
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
| pke-empire-os | Ops | Empire strategy |
| design-ui / imagine / … | App Builder | Product surfaces |

## Deploy order

1. Validate all skills (`validate-skill.sh` / `aleah-validate.mjs`)
2. Self-heal
3. Learn cycle
4. Brand app / Aleah smoke
5. Comfy graph offline-sim
6. GitHub push brand pack + mind + scripts + ecosystem map

## Commands

```bash
bash scripts/pke-self-heal.sh
bash scripts/pke-learn.sh
bash scripts/pke-learn.sh --push
node scripts/aleah-validate.mjs
python3 scripts/comfy-offline-sim.py
```
