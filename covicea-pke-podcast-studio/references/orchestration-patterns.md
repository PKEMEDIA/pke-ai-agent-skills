# Multi-Agent Orchestration Patterns (PKE Podcast Studio)

Production hybrid used by this skill (2026 best practice):

## Primary topology
**Supervisor / Magentic Orchestrator** — outer plan loop + inner execute loop; task ledger; corrective re-route.

## Core patterns encoded
1. **Sequential Pipeline** — Research → Write → Fact-check → Polish → Social (strict dependencies).
2. **Debate / Critique** — FactChecker critiques HeadWriter; max 2 rounds; hard ceiling on token burn.
3. **Fan-out Parallel** — SocialATSEnhancer generates multi-platform clip packs concurrently after script lock.
4. **Dynamic Handoff** — CoHost owns live reaction; Orchestrator pulls Research/Panel mid-turn when needed.
5. **Graph-style recovery** — validation gates as conditional edges; fail → rewrite loop → re-score.

## Avoid by default
- Full Swarm for single-episode production (chaos + cost).
- Unlimited debate rounds.
- Parallel branches that share unmerged partial scripts (context poison).

## Framework mapping (if local agents)
| Pattern | CrewAI | LangGraph | AutoGen / Magentic |
| --- | --- | --- | --- |
| Role crew | sequential/hierarchical | nodes + edges | GroupChat / Magentic manager |
| Critique | second pass agent | conditional retry | multi-round debate |
| Parallel clips | parallel tasks | Send API branches | concurrent agents |

## Self-heal checklist scores (0–100)
- Brand DNA match
- Episode Bible structure
- Fact / allegedly framing integrity
- Engagement / clip potential
- Spicy authenticity without brand harm

Ship threshold: all ≥ 95 or auto-revise once then escalate notes to user.
