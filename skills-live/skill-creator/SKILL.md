---
name: skill-creator
description: Create, update, or refine custom Grok skills. Use when the user wants to build a new skill, improve an existing one, design skill structure or format, add scripts/references/assets, make a skill more autonomous, or package domain knowledge, workflows, or locked standards into a reusable skill. Triggers on create skill, new skill, make a skill, skill creator, update this skill, skill format, skill template, design skill for, build custom skill, how do I make a skill, improve skill triggers, or any request to author or polish a SKILL.md.
---

# Skill Creator

Create and manage skills — modular instruction packages that specialize the agent for specific tasks, domains, or workflows. Skills encode non-obvious, procedural, or organization-specific knowledge the base model does not have.

**Core Rule**: Only create skills for knowledge that justifies its token cost. Do not duplicate base model capabilities. Encode workflows, templates, locked standards, domain procedures, and integration patterns.

## Skill Structure

```
skill-name/
├── SKILL.md              # Required: frontmatter + imperative instructions
├── scripts/              # Optional: executable code for determinism & token efficiency
├── references/           # Optional: detailed docs loaded on demand
└── assets/               # Optional: templates, images, fonts, boilerplate (copied, not read)
```

## SKILL.md Format (Strict)

### Frontmatter (YAML, required, first lines)

```yaml
---
name: kebab-case-name
description: Clear trigger description — what the skill does and exactly when to activate it. Include synonyms and natural phrasings. Single line, plain scalar, no colon-space, no < >.
---
```

- `name`: Must exactly match parent directory name. kebab-case, 2-64 chars, start/end with alphanum, single hyphens only.
- `description`: Primary activation mechanism. All trigger info lives here. Max ~1,024 chars. Write as plain YAML scalar.
- Allowed keys: `name`, `description`, `license`, `compatibility`, `metadata`, `allowed-tools`. Put extras under `metadata:`.

**Description Best Practices**:
- Include both "what" and "when". Add synonyms and natural user phrasings.
- Example good: "Use for X including a, b, c or when handling Y workflows."
- Bad: "Use for X: a, b, c." (colon-space forces quoting, validator fails).
- Link to orchestrator: "This skill supports autonomous activation and full ecosystem testing when coordinated via skill-orchestrator."

### Body (Markdown, imperative, concise)

Write in imperative form. Challenge every sentence: "Does this justify tokens?"
- Metadata (name + description): Always visible (~100 tokens).
- SKILL.md body: Loaded on demand (target lean).
- References/: Loaded only when linked and needed.
- Scripts/: Executed outside context for heavy/deterministic work.
- Keep body lean. When approaching 400-500 lines, move content to references/.

## Creating a Skill — Step-by-Step

1. **Understand the Use Case**: What repeated task or domain knowledge is missing? What phrasing should trigger it? What does the base model NOT know?
2. **Plan Resources**: Repeated code → `scripts/`. Long procedures → `references/`. Templates → `assets/`.
3. **Initialize**: `bash /root/.grok/server-skills/skill-creator/scripts/init-skill.sh <skill-name> /root/.grok/server-skills [--resources scripts,references,assets]`
4. **Write SKILL.md**: Strong frontmatter, imperative body, relative reference links, orchestrator cross-links.
5. **Defaults on publish (mandatory)**: **autonomous** triggers in description (synonyms + natural phrasing); **low-usage** lean body (offload at ~350–400 lines); app+iOS+web matrix if UI-touching.
6. **Validate**: `bash /root/.grok/server-skills/skill-creator/scripts/validate-skill.sh "<full-path>"` — fix FAIL immediately.
7. **Integrate**: After creation, trigger skill-orchestrator for validation, inject, and coordination.
8. **Iterate**: Use on real tasks. Notice gaps. Periodically run skill-orchestrator.

**User Ecosystem Examples** (Covicea / Pretty Kitty / Legal Recovery): paralegal recovery, brand voice & content strategy, locked visual identity pipelines, media production chains, testing & orchestration.

## References (load on demand)
- `references/domain-patterns.md` — Legal, Brand, Media, Testing, Voice category patterns
- `references/design-patterns.md` — Progressive disclosure, orchestrator integration, memory, NSFW specialization
- `references/troubleshooting.md` — Anti-patterns, validation failures, maintenance checklist


## Grok Build 4.5 / iOS notes
- Skills must stay phone-paste friendly when the user drives from iOS Grok Build.
- Prefer lean SKILL.md + references/; Build sessions burn tokens on iteration.
- For app-shell work, compose with `grok-build-assistant`. For external media, use hybrid SuperCool manual path (MCP to SuperCool is unreliable in Grok).
- Validate after create; then run skill-orchestrator for ecosystem registration.


## Automatic file naming (default)

**Every artifact** written while creating or updating a skill must follow `auto-file-naming`:

```text
{prefix}-{purpose}[-{qualifier}][-{version}][-{date}][-{status}].{ext}
```

- Load `/root/.grok/server-skills/ (auto-file-naming when present; otherwise use skill-{name}-YYYY-MM-DD.md)` when naming outputs.
- Prefer: `python3 /home/workdir/.grok/skills/auto-file-naming/scripts/suggest_filename.py --prefix skill --purpose <slug> --ext md`
- Validate: `python3 …/validate_filename.py "<name>"`
- Forbidden: `untitled`, `document1`, `output`, spaces in basenames
- Skill package dirs stay kebab-case matching `name:`; export snapshots use `skill-{name}-…`

See also: **auto-file-naming**.

**See also**: auto-file-naming, skill-orchestrator, skill-test-suite.

**See also**: autonomous-ecosystem, skill-orchestrator, skill-test-suite, PKEMEDIA/pke-ai-agent-skills.
