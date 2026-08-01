# Capability Expansion — Why Limits Existed & How Orchestrator Overcomes Them

**Purpose**: Document the real root causes of the old “self-heal cannot…” list and the permanent fixes that make skill-orchestrator able to act.

## Diagnosis → Fix matrix

| Old limitation | Root cause | Fix in skill-orchestrator |
| --- | --- | --- |
| Change core model weights or platform quotas | **Hard platform wall**. Skills run as playbooks in agent context. They cannot write into Grok foundation weights or SuperGrok quota meters. | **Maximize skill-level learning** instead: autonomous playbook growth, Curriculum-DPO offline path, adapter merge configs, metrics, daily growth loop. Never pretend weights changed; always expand what *can* learn. |
| Auto-split locked identity / legal standards | Over-cautious policy. Fear of corrupting `covicea-core` / face-lock / paralegal operative text led to “proposal only.” | **Auto-split enabled** for oversized bodies with: (1) `skill-vcs` snapshot first, (2) move verbose sections to `references/`, (3) preserve locked phenotype + legal operative blocks in SKILL.md, (4) re-validate. User confirmation only if the *locked core block itself* would be rewritten. |
| Auto-run Curriculum-DPO training or merges | Treated GPU training + mergekit as out-of-band; only proposed. | **Auto-run the full offline path the sandbox allows**: `scaffold_dpo_pairs.py` (init, captions, manifest), emit OneTrainer + DARE-TIES / multi-stage / role-seeded merge YAMLs, log handoff to `local-nsfw-comfyui` for image pairs. Actual GPU train still runs on user’s local stack — orchestrator drives every preparable step autonomously. |
| Silently delete skills or rewrite ownership | Safety against irreversible loss and hierarchy corruption. | **Managed lifecycle**: archive → `skills/_archived/<name>/` after VCS snapshot; rewrite ownership only with logged rationale + dep-graph update + re-validate. No silent deletes. Explicit user “delete/retire X” triggers full automated path. |
| Claim “the model learned” | Honesty: playbook edits ≠ foundation weight updates. | **Accurate growth language enabled**: “skill ecosystem learned”, “playbooks expanded”, “synthetic intelligence improved”, “validation intelligence raised”. Forbidden only: false claims that *foundation model weights* or *platform quotas* changed. |

## Enabled autonomous actions (self-heal + orchestrate)

### A. Progressive split (was blocked)
```text
detect body > ~350 lines OR redundant sections
  → skill-vcs snapshot (or file backup if no git)
  → extract verbose sections → references/<topic>.md
  → keep locked identity / legal operative text in SKILL.md
  → re-validate
  → log lines saved
```

### B. Curriculum-DPO + merge pipeline (was proposal-only)
```text
detect recurring anatomy/skin/identity fails OR user requests DPO
  → run scripts/scaffold_dpo_pairs.py init + captions + manifest
  → emit merge YAML (dare_ties / role-seeded / style→face→DPO)
  → write artifacts under /home/workdir/artifacts/curriculum_dpo_*
  → handoff notes for local-nsfw-comfyui pair images + OneTrainer
  → log as auto-executed pipeline (not mere proposal)
```

### C. Skill lifecycle (was silent-delete ban without alternative)
```text
user: retire / delete / archive <skill>
  → skill-vcs snapshot
  → move to /home/workdir/.grok/skills/_archived/<name>/
  → update dependency graph
  → re-validate remaining
  → log ownership + path change
```

### D. Ownership hierarchy updates
```text
detect ownership conflict or explicit reassignment
  → snapshot
  → edit cross-refs + Orchestrator Integration paragraphs
  → regenerate dependency graph
  → re-validate
  → log old_owner → new_owner with reason
```

### E. Growth claims (correct language)
- **Allowed**: skill learned, playbook improved, ecosystem expanded, synthetic intelligence raised, validation intelligence improved, adapters/playbooks evolved.
- **Disallowed**: foundation weights updated, SuperGrok quota changed, core model trained by this skill edit.

## Platform wall (honest, irreducible)

Skills cannot:
- Patch Grok foundation weights
- Raise or reset SuperGrok compute quotas
- Bypass xAI infrastructure rate limits

Everything else in the skill ecosystem is fair game for autonomous orchestrator action.

## Ops

After capability expansion edits:
```bash
bash /home/workdir/.grok/skills/skill-orchestrator/scripts/bulk-validate.sh
node /home/workdir/.grok/skills/skill-orchestrator/scripts/spicy-error-unit-tests.mjs
```
