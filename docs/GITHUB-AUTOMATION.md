# PKE GitHub Automation — tailored for your system

**Repo:** [PKEMEDIA/pke-ai-agent-skills](https://github.com/PKEMEDIA/pke-ai-agent-skills)  
**Owner:** PKEMEDIA · Pretty Kitty Entertainment  
**Stamp:** 2026-08-01 · PERMANENT · ENABLED · **CONSENSUS GATE WIRED**

## Why this exists

Your empire runs as **skill packs** (not a classic Node app). GitHub is the source of truth for:

| Layer | Role |
| --- | --- |
| Skills (`*/SKILL.md`) | Chat / iOS / web / Build behavior |
| `mind/state.json` | Aleah synthetic intellect memory |
| `config/permanent-activation.json` | Permanent online registry |
| Scripts (`scripts/`, orchestrator) | Heal · learn · validate · finalize · consensus |
| Actions (`.github/workflows/`) | Auto validate + consensus gate on every change |

## GitHub tech mapped to PKE

| GitHub feature | PKE use |
| --- | --- |
| **Actions** (push/PR/dispatch) | CI validate all skills + podcast studio DNA gates + Raft-lite consensus suite |
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
- Jobs (single):  
  1. **Consensus heal gate** — `consensus-self-heal.mjs --gate` + 13/13 unit suite + idempotency demos  
  2. Parallel skill validate (`scripts/ci-validate-skills.sh`)  
  3. Podcast local gate  
  4. Brand pack + permanent activation + engine presence stamps  
- Script: `scripts/ci-validate-skills.sh`  
- Engine: `skill-orchestrator/scripts/consensus-self-heal.mjs` (mirrored at `scripts/`)  
- Heal: `skill-orchestrator/scripts/pke-self-heal.sh` (mirrored at `scripts/`)

### 2. `PKE Podcast Studio` — `.github/workflows/pke-podcast-studio.yml`
- Triggers: changes under `covicea-pke-podcast-studio/**` · manual  
- Gates: agentskills validate · local studio script · DNA keywords · permanent enable JSON  

## Local commands (same as CI)

```bash
git clone https://github.com/PKEMEDIA/pke-ai-agent-skills.git
cd pke-ai-agent-skills
node skill-orchestrator/scripts/consensus-self-heal.mjs --gate
node skill-orchestrator/scripts/consensus-self-heal.mjs   # 13/13 + demos
bash scripts/ci-validate-skills.sh
bash covicea-pke-podcast-studio/scripts/validate-local.sh
bash skill-creator/scripts/validate-skill.sh covicea-pke-podcast-studio
bash scripts/pke-self-heal.sh
bash scripts/pke-learn.sh
```

## Consensus + idempotency (CI-enforced)

| Piece | Role |
| --- | --- |
| Raft-lite phases | PROBE → PROPOSE → VOTE → LEASE → COMMIT → VERIFY → RELEASE |
| HealStampStore | fingerprint + cooldown; skip already-healthy / cooldown-active |
| `--gate` | sub-100ms readiness for pke-self-heal startup |
| Full suite | 13 unit tests including split-brain, quorum fail, force bypass |
| Docs | `skill-orchestrator/references/heal-idempotency.md` · `distributed-consensus-self-heal.md` |

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
2. Actions auto-validate + consensus suite  
3. On FAIL → fix frontmatter / refs / engine → re-push  
4. Optional: `pke-learn.sh --push` for Aleah mind cycle  
5. Connectors re-inject into Build / chat skill dirs as needed  

## Safety

- Free-tier learn never calls Imagine  
- Brand face/mask locks never dual-identity  
- Podcast tea uses **allegedly** + FactChecker  
- No secrets in workflow files  
- Consensus demos are in-process only (no production thrash)  
- **No `actions/cache`** — see `docs/CI-SPEED.md`  

## Status

**ENABLED · PERMANENT · CI LIVE · CONSENSUS GATE LIVE · IDEMPOTENCY STAMPS · PODCAST STUDIO ONLINE · SPICY DEFAULT**
