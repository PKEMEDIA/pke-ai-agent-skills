# pke-ai-agent-skills

AI Agent Skills and Orchestrator for Pretty Kitty Entertainment business operations. Multi-agent system for content house, mentorship, production etc.

## Included Meta-Skills (Cursor / agentskills.io compatible)

### skill-creator
Create, scaffold, refine, and validate high-quality Agent Skills. Use this to turn workflows, domain knowledge, or processes into reusable skills that agents can discover and apply automatically.

### skill-orchestrator
Orchestrate complex multi-step tasks by inventorying available skills, decomposing goals, matching skills to subtasks, generating structured plans (sequential / parallel / DAG), managing handoffs, and synthesizing results.

## Quick Install for Cursor

```bash
# Project-level (recommended)
mkdir -p .cursor/skills
cp -r skill-creator skill-orchestrator .cursor/skills/

# Or user-level (global)
mkdir -p ~/.cursor/skills
cp -r skill-creator skill-orchestrator ~/.cursor/skills/
```

After placing the folders, restart Agent chat or reload Cursor. Invoke with:

- `/skill-creator`
- `/skill-orchestrator`

or natural language that matches their descriptions.

## How to Use

1. Use **skill-creator** to build new domain skills (content production pipelines, mentorship workflows, media production standards, legal recovery processes, etc.).
2. Use **skill-orchestrator** when you have a complex goal that benefits from coordinating multiple specialized skills.
3. Iterate: create → test → improve → orchestrate.

These skills follow the official Cursor Agent Skills format and the open [agentskills.io](https://agentskills.io) standard.

Official Cursor docs: https://cursor.com/docs/skills
