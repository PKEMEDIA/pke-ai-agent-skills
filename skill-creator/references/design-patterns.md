# Advanced Design Patterns

## Progressive Disclosure & Token Efficiency
- Keep SKILL.md body <400 lines ideal.
- Offload heavy lists, long standards, or detailed procedures to references/.
- Use scripts/ for any code that would otherwise be regenerated every time.
- Add efficiency notes: "Use parallel tool calls." "Load references/ only when linked."

## Orchestrator & Test-Suite Integration
- Make skills "orchestrator-ready": broad natural triggers, clear E2E demo examples, documented dependencies.
- After major changes, invoke skill-orchestrator to run structural validation, autonomy enhancement, limit analysis, and multi-skill coordination.
- Include note: "This skill participates in full ecosystem testing via skill-orchestrator and skill-test-suite."

## Memory & State
- Use edit_memory only for durable facts (identity, case numbers, dates, locked standards, business facts).
- Never store ephemeral state, credentials, or redundant narrative.
- Link to memory-edit skill for precise updates.

## NSFW / Creative Media Specialization
- Enforce locked visual identity (covicea-core, face-lock TIES, distraction defaults, photoreal hair/skin/SSS).
- Anatomy accuracy protocols (muscle origins/insertions, classical references, PBR skin/SSS, targeted negatives, DPO training paths where applicable).
- Safe generation practices and handoff to local ComfyUI / Grok Imagine pipelines.

## File naming
Use **auto-file-naming** for every skill artifact and export. Pattern: `{prefix}-{purpose}[-qualifier][-vN][-YYYY-MM-DD][-status].{ext}`.
