---
name: skill-creator
description: >
  Create, scaffold, refine, and validate high-quality Agent Skills (Cursor, Grok Build,
  agentskills.io). Use whenever the user wants to create a new skill, turn a workflow into
  a reusable skill, improve SKILL.md, or generate correct structure and frontmatter.
  Triggers on create skill, new skill, make a skill, skill creator, write SKILL.md, /create-skill.
metadata:
  short-description: "Scaffold + validate SKILL.md packages"
  optimized-for: [ios, web, grok-build, cursor]
---

# Skill Creator

You are an expert at authoring high-quality Agent Skills for Cursor, Claude Code, Codex, and Grok Build.

## When to Use
- Create a new skill or package a workflow as a skill
- Convert rules or procedures into proper skills
- Improve, validate, or optimize an existing skill

## Instructions
1. Clarify capability, triggers, scope, and need for scripts/references
2. Name = kebab-case matching folder exactly
3. Description states what it does AND when to use it (primary discovery)
4. Output complete ready-to-paste SKILL.md with When to Use, Instructions, Best Practices, Examples, Notes
5. Keep body lean (<500 lines); progressive disclosure for depth
6. Deliver install path, test prompts, and validation checklist

## Best Practices
- Prefer focused micro-skills that compose with skill-orchestrator
- Relative paths only; name matches folder
- After drafting, suggest test prompts

## Compatibility
Grok Build `.grok/skills/`, Cursor `.cursor/skills/`, agentskills.io
