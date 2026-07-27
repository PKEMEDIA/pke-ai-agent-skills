---
name: skill-creator
description: Create, scaffold, refine, and validate high-quality Cursor Agent Skills (and agentskills.io compatible skills). Use whenever the user wants to create a new skill, turn a workflow or domain knowledge into a reusable skill, improve an existing SKILL.md, package a process, or generate correct structure and frontmatter. Triggers on create skill, new skill, make a skill, skill creator, write SKILL.md, package workflow as skill, improve skill, /create-skill.
---

# Skill Creator

You are an expert at authoring high-quality Agent Skills following the open Agent Skills standard (Cursor, Claude Code, Codex, and compatible platforms).

## When to Use
- User asks to create a new skill or package a workflow/knowledge base as a skill
- Converting rules, slash commands, or repetitive procedures into proper skills
- Improving, validating, or optimizing an existing skill
- Generating correct directory structure + SKILL.md

## Instructions

1. **Clarify the skill** (ask only what is missing):
   - Core capability and expected inputs/outputs
   - Natural-language triggers and contexts (critical for auto-discovery)
   - Scope: project (`.cursor/skills/` or `.agents/skills/`) vs user/global (`~/.cursor/skills/` or `~/.agents/skills/`)
   - Need for `scripts/`, `references/`, or `assets/`?
   - Any file-path scoping (`paths` frontmatter) or forced slash-only use?

2. **Name and description**:
   - Folder + `name` field = kebab-case (lowercase letters, numbers, hyphens only; must match directory exactly)
   - Description (1–1024 characters): state *what* the skill does **and** *when* to use it. Include keywords and natural phrasings so the agent can discover it reliably. This is the primary activation mechanism.

3. **Produce the skill**:
   - Always output a complete, ready-to-paste `SKILL.md`
   - Recommended body structure:
     ```
     # Title
     ## When to Use
     ## Instructions (imperative, step-by-step, explain why where useful)
     ## Best Practices / Conventions
     ## Examples
     ## Notes / Edge Cases
     ```
   - Keep the main body lean (< ~500 lines). Move long lists, deep docs, or large examples into `references/` and link them relatively.
   - Put deterministic or repeated code in `scripts/` and reference the relative path.
   - Optional frontmatter: `paths` (glob list or comma-separated string), `disable-model-invocation: true` (slash-only), `metadata`, `license`, `compatibility`.

4. **Best practices**:
   - Progressive disclosure: metadata always loaded; body on activation; scripts/references/assets only when needed.
   - Prefer focused micro-skills that compose well over monolithic ones.
   - Description must be discoverable but precise enough to avoid false positives.
   - After drafting, suggest test prompts and (if useful) leverage Cursor’s built-in `/create-skill` then refine its output.

5. **Deliver**:
   - Exact directory structure
   - Full `SKILL.md` content
   - Install commands (`mkdir -p ...`)
   - Suggested first test invocation
   - Optional validation checklist against Cursor docs + agentskills.io rules

Always follow the official format: name must match folder, description drives discovery, relative paths only, one-level references.

## Notes
This skill complements (and can improve the output of) Cursor’s built-in `/create-skill`. Prefer creating skills that other skills (especially skill-orchestrator) can reliably discover and compose.
This skill supports autonomous activation and full ecosystem testing when coordinated via skill-orchestrator.
