# Limit Optimization Best Practices for Skill Ecosystem

## Core Principles
- **Progressive Disclosure**: Keep SKILL.md <500 lines. Move detailed procedures, long lists, templates, and edge-case discussions to references/<topic>.md. Link with "See references/xxx.md for full details."
- **Token Analysis**: Use `wc -l` and `wc -w` on SKILL.md and large references/ to flag bodies approaching 400-500 lines or with verbose/redundant sections.
- **Refactoring Patterns**:
  - Condense verbose sections into concise imperative bullets or numbered steps.
  - Offload heavy/repeated code to scripts/ (executed outside context for determinism and efficiency).
  - Add explicit efficiency notes in SKILL.md: "Use parallel tool calls where possible." "Load references/ only on demand."
- **Heavy Media & Code Skills**: Offload to scripts/ or external tools (ffmpeg, ComfyUI via local-nsfw-comfyui, generate_image). Avoid embedding long examples in core body.
- **Verification**: After edits, re-measure line counts. Run sample multi-step workflows to confirm smoother operation and reduced context consumption.
- **Related**: Skills with long code gen or media pipelines should prioritize script-based execution.

## Recommended References Structure
- activation-and-autonomy.md: Trigger optimization templates and broad vs narrow description examples.
- agent-meeting-protocol.md: Multi-skill consultation templates and synthesis guidelines.
- continuous-testing-loop.md: Iteration process pseudocode and report formats.
- limit-optimization.md: This file — reusable efficiency checklists and token analysis methods.

Update SKILL.md to reference these on demand. This supports scalable synthetic intelligence compositions without rapid limit exhaustion.

Last optimized: July 29, 2026 (daily re-orchestration; max body ~153 lines; no auto-split required; mp4 noise quarantined).