# Activation and Autonomy Best Practices

## Trigger Optimization Guidelines
- **Primary Mechanism**: The `description` field in frontmatter is the main trigger. Write it as a plain YAML scalar (no quotes, no `: ` colon-space, no `< >`).
- **Broaden for Natural Use**: Include synonyms, related scenarios, and common phrasings (e.g., "orchestrate skills autonomously", "full system validation and fix", "agent clarification meeting").
- **Add Coordination Notes**: Explicitly mention support for autonomous-like workflows when used with skill-orchestrator or skill-test-suite.
- **Precision Balance**: Avoid overly broad triggers that risk unintended activation. Test by confirming the description would match typical user language for the skill's purpose.
- **Autonomy Enhancement Loop**:
  1. Review existing descriptions for narrow/exact-phrase triggers.
  2. Edit to include natural language variants.
  3. Re-validate the skill.
  4. Document changes in memory or references.

## Examples of Effective Descriptions
- Good: "Use for comprehensive testing of all skills, autonomous activation, agent coordination meetings, and fixing context limits. Supports full system orchestration when triggered with skill-orchestrator."
- Avoid: Exact command lists only or descriptions with forbidden characters.

## Integration with Skill-Orchestrator
This skill supports broader autonomy when coordinated via skill-orchestrator. Use in combination for continuous health and self-improving synthetic intelligence ecosystems.

Last polished: July 18, 2026.