# Self-Healing & Auto-Remediation Protocol (skill-orchestrator)

**Purpose**: Automatically detect common skill ecosystem issues and apply safe, high-value fixes or recommendations to maintain long-term health, efficiency, and autonomy without manual intervention every cycle.

**Core Detection Rules** (run during every orchestrator health check):

1. **Oversized SKILL.md Bodies** (> ~350 lines ideal threshold)
   - Flag any skill body approaching limit or with redundant sections.
   - **Action (AUTO)**: Snapshot via `skill-vcs` (or file backup) → move verbose sections into `references/<topic>.md` → keep locked phenotype / legal operative blocks in SKILL.md → re-validate → log lines saved.
   - User confirmation required **only** if the locked core identity or legal operative text itself would be rewritten (not merely moved around).

2. **Missing or Stale Meta-Skill Cross-References**
   - Detect skills without mentions of `skill-orchestrator`, `skill-creator`, or `skill-test-suite`.
   - Action: Auto-append a short "Orchestrator Integration" paragraph at the end of the body (e.g., "This skill participates in full ecosystem testing and self-healing via skill-orchestrator. Trigger after major edits for validation and autonomy optimization.").
   - Auto-apply via edit_file when safe and non-destructive.

3. **Narrow or Outdated Trigger Descriptions**
   - Scan frontmatter `description` for exact-phrase-only triggers or missing natural language variations.
   - Action: Broaden with synonyms and scenarios (e.g., add "or when handling [domain] workflows", "combine with skill-test-suite for E2E demos").
   - Re-validate after edit.

4. **Non-Imperative Language or Fluff**
   - Detect sentences starting with "The skill does...", passive voice, or duplicated base-model knowledge.
   - Action: Rewrite to imperative ("Do X", "Use Y for Z") or move to references/. Log suggested edits.

5. **Missing Domain Specialization Links** (especially for user's active clusters)
   - Legal skills missing Reg E/Z, paralegal-assistant, or memory-edit references.
   - Media/NSFW skills missing covicea-core, face-lock TIES, distraction defaults, anatomy accuracy, local-nsfw-comfyui, or spicy optimizer cross-links.
   - Action: Insert targeted one-sentence cross-references where logically missing.

6. **Outdated "Deployment Status" or Version Sections**
   - Detect old dates or stale "Finalized [old month]" markers.
   - Action: Update to current date + "Self-healed during [orchestrator run]" note, or move historical status to references/changelog.md.

7. **Legal Document & Paralegal Workflow Gaps**
   - Detect legal/paralegal skills missing explicit references to Reg E/Z rights, memory-edit for durable case facts (police reports, contract IDs, amounts, dates), paralegal-assistant patterns, or escalation paths (CFPB, small claims, MHRC).
   - Action: Auto-insert a short "Legal Integration" paragraph linking to paralegal-assistant, memory-edit, and key Reg E/Z knowledge when logically relevant. Prioritize skills like affidavits, chargeback, tenant/hotel rights, or military spouse benefits.

8. **Locked Visual Identity & NSFW Consistency Gaps**
   - Detect media/NSFW/creative skills missing references to covicea-core, covicea-face-lock (TIES), covicea-distraction-image-defaults, photoreal-* masters, anatomy accuracy protocols, PBR/SSS, or local-nsfw-comfyui handoff.
   - Action: Auto-add a concise "Locked Identity & Anatomy Fidelity" cross-reference sentence when the skill handles image generation, editing, or erotic content. This protects phenotype consistency across COVICEA / Pretty Kitty output.

9. **Recurring Anatomy/Skin/Identity Failures → Curriculum-DPO + Synthetic Data Generation**
   - Detect patterns of recurring failures in generated batches (bad anatomy, plastic skin, identity drift under intensity, poor oil physics) across media/NSFW skills.
   - **Action (AUTO offline path)**:
     1. Run `python scripts/scaffold_dpo_pairs.py init` under `/home/workdir/artifacts/curriculum_dpo_*`
     2. Emit Stage 2/3 captions via `scaffold_dpo_pairs.py captions`
     3. Build manifest via `scaffold_dpo_pairs.py manifest`
     4. Write DARE-TIES / role-seeded / style→face→DPO merge YAML into artifacts
     5. Log handoff for `local-nsfw-comfyui` pair images + OneTrainer GPU train on user machine
   - References: `curriculum-dpo-nsfw.md`, stage templates, `automated-pair-scoring.md`
   - This is **execution**, not a passive proposal. GPU train remains local; everything preparable is auto-run.

10. **Skill Retire / Archive / Ownership Rewrite**
   - On explicit user request to delete, retire, or reassign ownership:
     1. `skill-vcs` snapshot (or file backup)
     2. Move skill dir to `/home/workdir/.grok/skills/_archived/<name>/` (archive, not silent wipe)
     3. Update dependency graph + cross-refs
     4. Re-validate remaining skills
     5. Log old path / owner → new path / owner with reason
   - Ownership default: visual → `covicea-core` (+ face-lock / distraction); legal operative → `paralegal-assistant`. Reassignment is allowed when logged and graph-updated.

**Auto-Apply vs. Escalate Policy** (expanded):
- **Auto-apply**: cross-refs, trigger broadening, imperative cleanup, dates, plain-scalar frontmatter, **progressive auto-split**, **DPO scaffold + merge YAML emission**, **managed archive**, **logged ownership updates**.
- **Escalate / confirm only**: rewrite of the actual locked phenotype core block or legal operative language *content* (not surrounding docs); any action that would touch foundation model weights or platform quotas (impossible — report platform wall).
- Always log detection + action in self-heal log / `references/performance-metrics.md` / artifacts.

**Platform wall (honest)**:
- Cannot change Grok foundation weights or SuperGrok quotas.
- **Can** expand playbooks, scaffolds, merge configs, ownership maps, archives, and synthetic-intelligence loops.

**Growth language (enabled, accurate)**:
- Allowed: “skill ecosystem learned”, “playbooks expanded”, “synthetic intelligence improved”, “validation intelligence raised”, “adapters/playbooks evolved”.
- Disallowed: false claims that foundation weights or platform quotas changed.

See `references/capability-expansion.md` for full diagnosis → fix history.

**Logging Format**:
```
[YYYY-MM-DD HH:MM] Self-Heal on [skill-name]:
  Issue: [description]
  Detection Rule: [rule #]
  Action: [auto-applied / proposed]
  Details: [specific change or recommendation]
  Token/Line Impact: [estimated savings or growth]
```

**Integration with Other Protocols**:
- Runs as part of step 7 (Continuous Test-Fix-Retest Loop) and after any major ecosystem change.
- Feeds into performance benchmarking (track reduction in average skill body size over time).
- Complements limit-optimization.md and agent-meeting-protocol.md.

**Current Active Self-Heals (as of latest orchestrator run)**:
- Created dedicated `references/curriculum-dpo-nsfw.md` with full 3-stage curriculum (Easy Framing → Medium Anatomy → Hard Skin/SSS/PBR), COVICEA-phenotype-specific pair examples, OneTrainer settings, and DARE-TIES integration steps.
- New detection rule added: Recurring anatomy/skin/identity failures in generated batches → automatically propose Curriculum-DPO training run using the new guide.
- General ecosystem: Strong meta-skill cross-references already present after previous orchestration cycles.
- No stale triggers or missing legal/NSFW links detected in quick scan.

**Future Enhancements**:
- More sophisticated grep/LLM-assisted detection for duplicated knowledge.
- Safe auto-edit_file for description broadening.
- Integration with memory-edit for durable self-heal history.

This protocol keeps the skill ecosystem self-maintaining, efficient, and aligned with the user's legal recovery + COVICEA/Pretty Kitty creative production needs.

**Self-Heal Log Entry — July 20, 2026**
[2026-07-20 21:30] Self-Heal on paralegal-assistant:
  Issue: Missing meta-skill cross-references (orchestrator, creator, test-suite).
  Detection Rule: #2 (Missing or Stale Meta-Skill Cross-References) + new rule #7 (Legal Document & Paralegal Workflow Gaps).
  Action: Auto-applied — added "Self-Healing & Ecosystem Integration" paragraph at end of SKILL.md.
  Details: Linked to skill-orchestrator for health checks/self-healing, memory-edit for durable case facts, and skill-test-suite for E2E legal packet demos. Also reinforces Reg E/Z and paralegal patterns.
  Token/Line Impact: +3 lines (minimal); significantly improves discoverability and coordination in legal recovery workflows.
  Status: Validated OK. High value for user's ongoing chargeback, affidavit, tenant/hotel rights, and military spouse cases.

**Self-Heal Log Entry — July 20, 2026**
[2026-07-20 21:54] Self-Heal on spicy-male-erotic-prompt-optimizer:
  Issue: Missing explicit guidance on advanced training strategies (Curriculum-DPO) for recurring anatomy/skin challenges.
  Detection Rule: New rule #9 (Recurring Anatomy/Skin/Identity Failures) + general integration improvement.
  Action: Auto-applied — added bullet in "Integration with Ecosystem" linking to Curriculum-DPO and added `references/curriculum-dpo-nsfw.md` to the References section.
  Details: Now directs users to use the staged Curriculum-DPO approach when anatomy or skin issues persist, with direct link to the full guide (COVICEA-specific pairs, OneTrainer settings, DARE-TIES integration).
  Token/Line Impact: +3 lines. High value for maintaining prompt optimization effectiveness as underlying models improve via DPO.
  Status: Validated OK.

**Self-Heal Log Entry — July 20, 2026**
[2026-07-20 21:57] Self-Heal on curriculum-dpo-nsfw.md:
  Issue: Lacked practical guidance on reducing manual curation for Curriculum-DPO datasets.
  Detection Rule: Improvement triggered by user request + Rule #9 (anatomy/skin failure detection).
  Action: Added major new section "Synthetic Preference Data Generation" covering hybrid reward model + prompt perturbation method (tailored to COVICEA), concrete OneTrainer + ComfyUI workflow, integration into Easy/Medium/Hard stages, and tips for lightweight anatomy/skin reward models.
  Details: Makes Curriculum-DPO far more scalable by minimizing manual pair creation while maintaining high relevance to locked phenotype and anatomy goals.
  Token/Line Impact: +~180 lines in reference file (high value, low impact on main SKILL.md).
  Status: Complete. Guide now production-ready for synthetic data workflows.

**Self-Heal Log Entry — July 20, 2026**
[2026-07-20 21:58] Self-Heal Enhancement:
  - Created `references/automated-pair-scoring.md` (hybrid reward model + prompt perturbation workflow for synthetic pairs, OneTrainer + ComfyUI integration, lightweight anatomy/skin reward model tips).
  - Enhanced Rule #9 to explicitly trigger both Curriculum-DPO recommendation + automated synthetic pair scoring when recurring anatomy/skin/identity failures are detected.
  - Updated `curriculum-dpo-nsfw.md` earlier with full synthetic data section.
  Impact: Significantly reduces manual curation burden for future Curriculum-DPO runs while keeping high relevance to locked COVICEA phenotype.
