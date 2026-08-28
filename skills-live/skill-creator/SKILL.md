---
name: skill-creator
description: Create, update, or refine custom Grok skills. Use when the user wants to build a new skill, improve an existing one, design skill structure or format, add scripts/references/assets, make a skill more autonomous, package domain knowledge, polish a SKILL.md, or deploy a skill to Grok bot. Triggers on create skill, new skill, make a skill, skill creator, update this skill, skill format, skill template, design skill for, build custom skill, how do I make a skill, improve skill triggers, deploy skill to grok bot, or any request to author or polish a SKILL.md. This skill supports autonomous activation and full ecosystem testing when coordinated via skill-orchestrator.
metadata:
  short-description: Author, polish, and package Grok skills
  argument-hint: "[skill-name or polish target]"
  surfaces: grok-bot, grok-chat, grok-ios, grok-web, grok-build, grok-cli
  slash: /skill-creator
---

# Skill Creator

Create and manage skills — modular instruction packages that specialize the agent. Encode non-obvious, procedural, or organization-specific knowledge the base model does not have.

**Core rule.** Only create a skill if the knowledge justifies its token cost. Do not duplicate base model capabilities. Encode workflows, templates, locked standards, domain procedures, and integration patterns.

## Skill structure

```
skill-name/
├── SKILL.md         # Required — frontmatter + imperative instructions
├── scripts/         # Optional — deterministic work outside context
├── references/      # Optional — loaded on demand
└── assets/          # Optional — copied, not read
```

## Frontmatter (strict — PKE CI)

Allowed top-level keys only: `name`, `description`, `license`, `compatibility`, `metadata`, `allowed-tools`.

Grok also understands `user-invocable`, `when-to-use`, `argument-hint`, `paths`. **Put those under `metadata:`** so `validate-skill.sh` stays green.

- `name` — kebab-case, matches directory, 2–64 chars, start/end alphanumeric, no consecutive hyphens, unquoted.
- `description` — what + when + synonyms. Plain YAML scalar. Max 1024 chars. **No colon-space, no quotes, no angle brackets, no TODO.**

## Body

Imperative. Challenge every sentence: does this justify tokens?

- Keep lean. At ~350–400 lines, move detail to `references/`.
- Link references relatively. Load only when needed.
- Cross-link skill-orchestrator and skill-test-suite.
- Portable paths. Never hardcode `/root/.grok/server-skills`. Resolve in order: `$PKE_ROOT`, `~/.grok/skills`, `/workspace/.grok/skills`, repo root.

## Perfect-a-skill loop

1. **Recall** — read the existing SKILL.md + references + scripts.
2. **Audit** — run `validate-skill.sh`. Score triggers, length, hardcoded paths, missing orchestrator link, duplicate see-also, missing metadata.
3. **Improve** — broaden triggers, lean the body, split references, add Grok-bot slash + surfaces in metadata, fix paths.
4. **Validate** — `bash "$CREATOR/scripts/validate-skill.sh" "<dir>"` until OK.
5. **Integrate** — trigger skill-orchestrator (inventory, dep graph, agent meeting if the skill sits on a sequence).
6. **Deploy** — symlink `~/.grok/skills/<name>`, copy into Build `.grok/skills/`, paste to grok.com custom skills. Slash `/<name>`.
7. **Automate** — if it should run daily, add a Grok automation whose prompt names the skill.

Init (portable):

```bash
CREATOR="$(dirname "$0")/.."   # or $PKE_ROOT/skill-creator
bash "$CREATOR/scripts/init-skill.sh" <skill-name> "$PKE_ROOT"
bash "$CREATOR/scripts/validate-skill.sh" "$PKE_ROOT/<skill-name>"
```

## Quality rubric

| Gate | Pass |
| --- | --- |
| CI frontmatter | validate-skill.sh OK |
| Triggers | what + when + ≥3 natural phrasings |
| Lean | body < 350 lines or split with locked blocks kept |
| Portable | no `/root/.grok` hardcodes |
| Ecosystem | orchestrator + test-suite mentioned |
| Bot | metadata.slash + surfaces |
| Honest | no claim of weight/quota changes |

Domain patterns: `references/domain-patterns.md`.
Design patterns: `references/design-patterns.md`.
Troubleshooting: `references/troubleshooting.md`.

Pretty Kitty examples: paralegal recovery, brand voice, locked visual identity, media chains, testing and orchestration.

**See also:** skill-orchestrator, skill-test-suite, autonomous-ecosystem, PKEMEDIA/pke-ai-agent-skills.
