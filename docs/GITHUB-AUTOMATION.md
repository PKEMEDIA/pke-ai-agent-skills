# PKE GitHub Automation — tailored for your system

**Repo:** [PKEMEDIA/pke-ai-agent-skills](https://github.com/PKEMEDIA/pke-ai-agent-skills)  
**Owner:** PKEMEDIA · Pretty Kitty Entertainment  
**Stamp:** 2026-08-01 · PERMANENT · ENABLED

## Why this exists

Your empire runs as **skill packs** (not a classic Node app). GitHub is the source of truth for:

| Layer | Role |
| --- | --- |
| Skills (`*/SKILL.md`) | Chat / iOS / web / Build behavior |
| `mind/state.json` | Aleah synthetic intellect memory |
| `config/permanent-activation.json` | Permanent online registry |
| Scripts (`scripts/`, orchestrator) | Heal · learn · validate · finalize |
| Actions (`.github/workflows/`) | Auto validate on every change |

## GitHub tech mapped to PKE

| GitHub feature | PKE use |
| --- | --- |
| **Actions** (push/PR/dispatch) | CI validate all skills + podcast studio DNA gates |
| **workflow_dispatch** | Manual re-enable / validate without code change |
| **path filters** | Podcast workflow only runs when studio files change |
| **concurrency groups** | Cancel stale CI on fast pushes |
| **Issues** | Deploy / activation trackers |
| **Connectors (Grok)** | Push files, read tree, trigger Actions, stamp mind |
| **Branches** | `main` is production skill pack |

Related private stacks (not skill CI targets):

- `PKEMEDIA/comfyui` — face-lock Comfy graphs  
- `PKEMEDIA/SentientEmpireOffice` — SwiftUI / Mac compile studio  

## Workflows shipped

### 1. `PKE Skill CI` — `.github/workflows/pke-skill-ci.yml`
- Triggers: push/PR to main · manual dispatch  
- Jobs: full skill validate · brand pack presence · permanent activation stamp  
- Script: `scripts/ci-validate-skills.sh`

### 2. `PKE Podcast Studio` — `.github/workflows/pke-podcast-studio.yml`
- Triggers: changes under `covicea-pke-podcast-studio/**` · manual  
- Gates: agentskills validate · local studio script · DNA keywords · permanent enable JSON  

## Local commands (same as CI)

```bash
git clone https://github.com/PKEMEDIA/pke-ai-agent-skills.git
cd pke-ai-agent-skills
bash scripts/ci-validate-skills.sh
bash covicea-pke-podcast-studio/scripts/validate-local.sh
bash skill-creator/scripts/validate-skill.sh covicea-pke-podcast-studio
bash scripts/pke-self-heal.sh
bash scripts/pke-learn.sh
```

## Permanent activation

`config/permanent-activation.json` marks:

- **covicea-pke-podcast-studio** → permanent · spicy · continuous recall  
- **skill-orchestrator** · **pke-synthetic-intellect** · face/mask locks  

Chat triggers still work:

```text
Activate PKE Podcast Studio
Produce episode on [topic]
React live as co-host
```

## Optimize loop

1. Edit skill → push main  
2. Actions auto-validate  
3. On FAIL → fix frontmatter / refs → re-push  
4. Optional: `pke-learn.sh --push` for Aleah mind cycle  
5. Connectors re-inject into Build / chat skill dirs as needed  

## Safety

- Free-tier learn never calls Imagine  
- Brand face/mask locks never dual-identity  
- Podcast tea uses **allegedly** + FactChecker  
- No secrets in workflow files  

## Status

**ENABLED · PERMANENT · CI LIVE · PODCAST STUDIO ONLINE · SPICY DEFAULT**
