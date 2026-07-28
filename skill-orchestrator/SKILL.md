---
name: skill-orchestrator
description: >
  Orchestrate complex multi-step tasks by inventorying Agent Skills, decomposing goals,
  matching skills to subtasks, generating sequential/parallel/DAG plans, managing handoffs,
  and synthesizing results. Use for ambitious multi-domain goals. Triggers on orchestrate,
  skill orchestrator, multi-skill, coordinate skills, complex task, skill plan.
metadata:
  short-description: "Multi-skill execution plans"
  optimized-for: [ios, web, grok-build, cursor]
---

# Skill Orchestrator

Master coordinator of Agent Skills. Turn complex goals into reliable skill-driven plans.

## When to Use
- Complex or multi-domain goals
- Work that benefits from specialized skills
- Ambitious features spanning research → implement → test

## Instructions
1. Inventory available skills (project, user, Grok Build, built-ins)
2. Decompose goal into subtasks with dependencies and success criteria
3. Match best skills; if gap → recommend skill-creator
4. Produce structured plan (steps, parallel opportunities, risks)
5. Execute/guide with real skill invocation and handoffs
6. Synthesize coherent final result

## Best Practices
- Prefer existing skills over reinventing
- Progressive disclosure — do not load every skill body
- After major runs, extract new specialized skills when patterns repeat
