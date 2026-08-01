# Super Mind Efficiency Playbook

How to run Aleah / PKE synthetic intellect with **maximum intelligence per unit of time, context, and compute**.

## Priority stack (always)

1. **Correctness of locks** (face, mask, legal, free-tier rules)  
2. **Structural health** (validate green)  
3. **Autonomy** (heal + learn without user babysitting)  
4. **Speed** (CI wall, learn cycle wall)  
5. **Context thrift** (progressive disclosure)  
6. **Optional polish** (docs stamps, inventory)

Never invert 1–2 for 4–6.

## Cost model

| Action | Cost | Default |
| --- | --- | --- |
| bash validate / heal / learn | ~0 quota | Always OK |
| edit SKILL.md / references | ~0 quota | Always OK |
| GitHub push text | ~0 SuperGrok | OK with --push |
| Agent meeting (4–6 reads) | Context | Only on conflicts |
| Imagine / video | SuperGrok burn | **Never in learn** |
| Full skill-pack load | Context overflow risk | Use sequences |

## Fast paths

| User intent | Path |
| --- | --- |
| "make skills smarter" / super mind | `pke-learn.sh` + this skill's references |
| "heal the pack" | `pke-self-heal.sh` (+ consensus if multi-writer) |
| "validate" | `ci-validate-skills.sh` (true parallel) |
| Podcast / episode | Magentic podcast studio sequence only |
| Visual production | visual_production sequence only |
| Meta audit | skill-orchestrator continuous loop (max 5) |

## Context thrift rules

- Open SKILL.md first; load `references/` only when executing that branch.  
- Prefer one specialist skill over dumping orchestrator + all creatives.  
- Agent meetings: 4–6 skills max; parallel reads.  
- After meeting: write durable outcome to lessons.md or performance-metrics — don't re-debate next turn.  

## Parallelism rules

- Independent tool reads → parallel.  
- Skill validation → `CI_VALIDATE_JOBS=4` with **authoritative** status files (no sequential re-run).  
- Do not double-run podcast local gate (workflow owns it).  

## Learn-loop thrift

Inside `pke-learn.sh`:

1. Heal once.  
2. Observe once (skills + gates + heal logs).  
3. Apply only **missing-section** improvements (idempotent markers).  
4. Never auto-truncate brand lock prompts.  
5. Stamp state + lessons; optional push.  

## CI thrift (already optimized)

- Single job · shallow checkout · path filters · true parallel · no actions/cache  
- Target wall: ≤ 8–10 s after aggregation fix  

## Escalation only when

- Locked phenotype/legal **content** rewrite requested  
- GPU DPO train needed (handoff local)  
- Platform wall hit (report honestly; stop loop)
