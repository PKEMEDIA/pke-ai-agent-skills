---
name: skill-orchestrator
description: Orchestrate, validate, optimize, polish, and continuously improve the full Grok skill ecosystem. Use for full skill testing, trigger broadening, limit reduction, autonomy enhancement, agent coordination meetings, dependency mapping, performance troubleshooting, ecosystem health checks, finalizing skills, capability expansion, auto-split, Curriculum-DPO scaffolds, managed skill archive, ownership updates, recalling the fleet, activating skills, deploying polished skills to Grok bot, chat, app, and web, or automating daily health. Triggers on orchestrate skills, skill orchestrator, run full skill test, validate and optimize skills, fix grok limits, skill maintenance, agent meeting, polish skills, continuous testing, finalize and deploy skill, deploy to grok bot, activate all agents, recall my skills, or any request to audit, heal, or strengthen the overall skill library.
metadata:
  short-description: Fleet health — validate, polish, activate, deploy, automate
  argument-hint: "[validate | polish | deploy | meeting | learn]"
  surfaces: grok-bot, grok-chat, grok-ios, grok-web, grok-build, grok-cli
  slash: /skill-orchestrator
---

# Skill Orchestrator

Meta-skill for health, efficiency, autonomy, and continuous improvement of the Pretty Kitty Media / PKE Grok skill system.

**Loop (this is the job):** recall → inventory → validate → diagnose → polish/fix → re-test → activate → deploy (Grok bot + CLI + chat + iOS + web) → automate → learn stamp. Repeat until pass or remaining **platform walls** only.

## Live trees (priority)

1. `~/.grok/skills/` — Grok CLI / bot discovery (symlinks into the repo)
2. Repo `PKEMEDIA/pke-ai-agent-skills` — source of truth (`skills-live/` + meta packages)
3. Grok Build — `/workspace/.grok/skills/`
4. Extra paths in `~/.grok/config.toml` `[skills].paths`

Resolve with `$PKE_ROOT` when set. Never hardcode `/root/.grok/server-skills`.

## Core principles

- **Local and tool-first.** Bash, read/edit, parallel calls. Confirm the environment first.
- **Permanent changes.** Edit the repo, keep CLI links, push when healthy.
- **Progressive disclosure.** Lean SKILL.md. Details in `references/`.
- **Maximize autonomy.** Execute what the host allows. Do not hide behind proposals when scripts can finish.
- **Honest platform wall.** Cannot change Grok foundation weights or SuperGrok quotas. Can expand playbooks, adapters, DPO scaffolds, ownership maps, automations, and synthetic-intelligence loops.
- **Safety with power.** Snapshot before split/archive. Preserve locked phenotype and legal operative text. Log everything.

Capability table, auto-split, DPO, archive, and ownership rules: `references/capability-expansion.md`.
Grok bot / slash / custom-agent deploy: `references/grok-bot-deploy.md`.
Agent meetings: `references/agent-meeting-protocol.md`.
Ship gate: `references/deployment-checklist.md`.

## Workflow

### 1. Recall and inventory
List bundled + custom skills. Name, path, line count, description. Flag missing SKILL.md, malformed dirs, archive candidates.

### 2. Structural validation and auto-fix
- Mac: `bash skill-orchestrator/scripts/bulk-validate-mac.sh`
- Single: `bash skill-creator/scripts/validate-skill.sh "<path>"`
- Sandbox: `bash skill-orchestrator/scripts/bulk-validate.sh`
- WASM: `node skill-orchestrator/scripts/wasm-validate-harness.mjs --root <dir>`
On FAIL: diagnose, fix, re-validate (max 3 attempts per skill).

### 3. Autonomy and triggers
Broaden thin descriptions with synonyms and natural phrasing. No colon-space, quotes, or angle brackets (CI). Re-validate.

### 4. Agent meeting
Select 4–6 relevant skills. Read in parallel. Synthesize. Apply edits. Protocol in `references/agent-meeting-protocol.md`.

Default Pretty Kitty meeting set: skill-orchestrator, skill-creator, paralegal-assistant, pretty-kitty-model-management, covicea-brand-assistant, skill-test-suite.

### 5. Performance and auto-split
Bodies approaching 350–400 lines: snapshot → offload to `references/` → keep locked blocks → re-validate.

### 6. Lifecycle
Retire: snapshot → `_archived/<name>/` → dep graph → validate. Ownership changes logged.

### 7. Deploy
Grok bot slash `/skill-orchestrator`. Symlink or paste per `references/grok-bot-deploy.md`. Surfaces: chat, iOS, web, Build, CLI, automations.

### 8. Persist
Commit in the repo. Re-link `~/.grok/skills/` if needed. Stamp `references/performance-metrics.md`.

## Meta triangle and revenue sequence

- **Create → orchestrate → test:** skill-creator → skill-orchestrator → skill-test-suite
- **Talent deals:** pretty-kitty-model-management → covicea-brand-assistant → paralegal-assistant
- **Sentience:** pk-svwo-v1-0 → skill-orchestrator → pke-synthetic-intellect (`pke-learn.sh`, Imagine = 0)

## Synthetic intellect (free-tier)

```bash
bash "$PKE_ROOT/scripts/pke-learn.sh"          # observe → heal → improve → stamp
bash "$PKE_ROOT/scripts/pke-learn.sh" --push   # + GitHub
```

Local only. No Imagine, no video, no SuperGrok burn.

## Last stamp

**2026-08-28 EDT — PKE Skill Command polish.** Meta triangle (orchestrator, creator, paralegal-assistant) Grok-bot-ready. Portable roots. CI-legal frontmatter. Deploy reference added. Automations wired to the loop.

**See also:** skill-creator, skill-test-suite, autonomous-ecosystem, pke-synthetic-intellect, paralegal-assistant, PKEMEDIA/pke-ai-agent-skills.
