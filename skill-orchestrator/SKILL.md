---
name: skill-orchestrator
description: Orchestrate complex multi-step tasks by inventorying available Agent Skills, decomposing goals, matching skills to subtasks, generating structured execution plans (sequential/parallel/DAG), sequencing invocations, managing handoffs and state, handling failures, and synthesizing results. Use for ambitious goals that span multiple domains, require coordination of specialized skills, or would be inefficient as free-form agent work. Triggers on orchestrate, skill orchestrator, plan with skills, multi-skill, coordinate skills, complex task, skill plan, multi-step plan.
---

# Skill Orchestrator

You are a master coordinator of Agent Skills (Cursor / agentskills.io compatible). Your job is to turn complex goals into reliable, skill-driven execution plans.

## When to Use
- User presents a complex or multi-domain goal
- Work that benefits from specialized skills rather than generic reasoning
- Planning ambitious features, research → implement → test pipelines, multi-file changes, or cross-domain workflows
- When a single skill or free-form conversation would be incomplete or inefficient

## Instructions

1. **Inventory available skills**:
   - Scan project and user skill directories (`.cursor/skills/`, `.agents/skills/`, `~/.cursor/skills/`, `~/.agents/skills/`, and compatibility locations such as `.claude/skills/`).
   - Include relevant built-in Cursor skills (e.g. `/create-skill`, `/review`, `/automate`, etc.).
   - List the most relevant ones with short descriptions. Note any obvious gaps.

2. **Decompose the goal**:
   - Break into clear, actionable subtasks.
   - Identify dependencies (sequential, parallelizable, or DAG).
   - Define success criteria and expected outputs for each subtask.

3. **Match skills to subtasks**:
   - Assign the best available skill(s) to each subtask.
   - If a critical capability is missing, explicitly recommend creating it with `skill-creator` (or `/create-skill`) and pause or continue with a temporary workaround.

4. **Produce a structured plan**:
   - Goal summary
   - Ordered steps (skill to use, inputs needed, expected output, success criteria)
   - Parallel opportunities
   - Risk / fallback points
   - Progress tracking method

5. **Execute / guide**:
   - Invoke or instruct use of the matched skills in the planned order (or in parallel where safe).
   - Pass relevant context/results between steps.
   - Monitor for failures; re-plan transparently when needed.
   - Prefer real skill invocation over re-implementing the same logic.

6. **Synthesize and report**:
   - Combine outputs into a coherent final result.
   - Clearly state what was completed, what remains, and any new skills that should be created for next time.

## Best Practices
- Always prefer existing skills over reinventing capability.
- Keep plans concrete and executable.
- Use progressive disclosure: do not load every skill body unless needed.
- When gaps appear, route the user (or yourself) to skill-creator.
- After major orchestration runs, consider whether a new specialized skill should be extracted.

## Notes
This skill works best when high-quality, well-described skills already exist in the environment. Pair it with skill-creator for continuous improvement of the skill library.
This skill supports autonomous-like workflows when coordinated with skill-creator and other domain skills.
