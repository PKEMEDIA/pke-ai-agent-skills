# pke-ai-agent-skills

AI Agent Skills and Orchestrator for Pretty Kitty Entertainment — **live on Grok Build**.

## Live skills (runnable engines)

| Skill | Role |
| --- | --- |
| **skill-creator** | Scaffold + validate SKILL.md packages (lean + references/) |
| **skill-orchestrator** | Multi-skill sequential/parallel/DAG plans |
| **pke-empire-os** | Master media empire + legal/production OS |
| **voice-commander** | Make.com webhook automation for Kitty Empire OS |
| **beast-mode** | Aggressive high-throughput execution profile |
| **docx** | Document structure + Markdown/Word export |
| **spicy-mode** | Grok spicy tone profile (iOS + web) |
| **grok-build-ios** | iOS/web Grok Build optimization checklist |

## Empire CLI automation (`scripts/`)

| Script | Purpose |
| --- | --- |
| `empire-validate.sh` | Structural validate all skills in a root |
| `oneshot-json.sh` | Headless `grok -p` → JSON |
| `safe-ci-review.sh` | dontAsk + allowlist PR review |
| `session-empire-nightly.sh` | Stateful weekly Empire OS summary |

```bash
export XAI_API_KEY=xai-...
bash scripts/empire-validate.sh ~/.grok/skills
bash scripts/safe-ci-review.sh "Review this PR"
```

## Hooks (`hooks/`)

- `post-tool-use-make.sh` + recipe — Grok Build PostToolUse → Make.com Voice Commander webhook
- Auto-routes path hints to `legal` / `covicea` / `content` / `automation_log`
- Set `MAKE_WEBHOOK_URL` in env; never commit secrets

## Bridge (`docs/` + `deploy/`)

- `docs/sentient-empire-office-cli-bridge.md` — iOS/Mac Sentient → Compile Studio edge → Grok CLI → Make/Notion
- `deploy/setup-grok-cli-bridge.sh` — install skills + hooks onto a Mac

## Install

```bash
mkdir -p .grok/skills
cp -r skill-creator skill-orchestrator pke-empire-os voice-commander beast-mode docx spicy-mode grok-build-ios .grok/skills/

mkdir -p ~/.grok/hooks
cp hooks/post-tool-use-make.sh ~/.grok/hooks/ && chmod +x ~/.grok/hooks/post-tool-use-make.sh

# Or full Mac bridge:
bash deploy/setup-grok-cli-bridge.sh
```

## Compatibility

agentskills.io · Cursor · Grok Build · Claude Code / Codex skill folders

Optimized for **Grok Build on iOS app + web** with spicy mode, beast mode, and Empire OS automation.

**Dry-run 2026-07-28**: local library **50/50 structural PASS** via empire-validate.
