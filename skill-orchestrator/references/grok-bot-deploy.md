# Grok bot deploy

How a polished skill becomes live on Grok (chat, iOS, web, CLI, Build, automations).

## Discovery (Grok loads automatically)

- `./.grok/skills/` (walked up to repo root)
- `~/.grok/skills/`
- Enabled plugin `skills/` directories
- Extra paths under `[skills] paths` in `~/.grok/config.toml`

User-invocable skills appear as slash commands: `/<skill-name>`.

## Packet (do this in order)

1. Validate — `bash skill-creator/scripts/validate-skill.sh "<skill-dir>"` must print OK.
2. Source of truth — skill lives in `PKEMEDIA/pke-ai-agent-skills` (package dir and/or `skills-live/<name>`).
3. CLI / bot — symlink `~/.grok/skills/<name> -> $PKE_ROOT/<name>` (or `skills-live/<name>`).
4. Build sandbox — copy or symlink into `/workspace/.grok/skills/<name>`.
5. grok.com custom skill — paste `SKILL.md` body into the Skills UI. Keep the same `name:`.
6. Automation — Grok scheduled task whose prompt names the skill (`skill-orchestrator`, `paralegal-assistant`, …).
7. Stamp — orchestrator performance-metrics + permanent-activation.json if the skill is permanent.

## config.toml snippet

```toml
[skills]
paths = [
  "~/PKE/pke-ai-agent-skills",
  "~/PKE/pke-ai-agent-skills/skills-live",
]
```

## Honest limits

- Placing a folder on disk does not rewrite Grok foundation weights.
- grok.com custom skills are a paste/install, not a hidden API from this app.
- Automations run the prompt you write — name the skill and the loop explicitly.

## Meta triangle slash commands

- `/skill-orchestrator`
- `/skill-creator`
- `/paralegal-assistant`
