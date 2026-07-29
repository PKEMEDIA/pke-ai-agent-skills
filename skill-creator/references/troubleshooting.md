# Anti-Patterns & Troubleshooting

## Anti-Patterns (Strict)
- Duplicating base model knowledge.
- Putting trigger info in the body (only frontmatter description).
- Creating README.md, CHANGELOG.md, or human-facing docs (skills are for agents).
- Nesting references (one level deep only).
- Exceeding ~500 lines in SKILL.md body without offloading to references/.
- Using colon-space or angle brackets in description.
- Overly narrow triggers that require exact phrasing (balance with natural language support).

## Troubleshooting & Common Issues
- Validation fails on description: Check for colon-space, quotes, <>, multi-line without proper scalar.
- Name mismatch: Directory name must exactly equal frontmatter `name:`.
- Skill not activating: Improve description with more natural phrasings and synonyms; then run skill-orchestrator to broaden triggers.
- Token limits hit fast: Refactor to references/ and scripts/; add "Use parallel tool calls" notes.
- After creating new skill: Immediately run skill-orchestrator for validation, autonomy optimization, and integration testing.

## Maintenance & Ecosystem Health
Skills in `/home/workdir/.grok/skills/` persist and override bundled versions. Bundled skills in `/root/.grok/skills/` are defaults.

After any creation or major edit:
1. Run validate-skill.sh.
2. Trigger skill-orchestrator for full structural validation, limit optimization, trigger broadening, and agent coordination meeting.
3. Test E2E via skill-test-suite where applicable.
4. Document changes in references/changelog.md if needed.
