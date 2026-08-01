# Deployment Checklist — skill-orchestrator

**Purpose**: Gate every ecosystem ship to chat · iOS · web. Run before calling Finalize complete or after skill-creator publishes.

Last updated: 2026-07-28

---

## Pre-flight (always)

- [ ] Working tree under `/home/workdir/.grok/skills/` is the source of truth (not `/tmp`)
- [ ] No unvalidated `edit_file` / `write_file` pending re-check
- [ ] Platform wall understood: no claim of foundation-weight or SuperGrok-quota change

## Structural & tests

- [ ] `bash /root/.grok/skills/skill-creator/scripts/validate-skill.sh` OK on every touched skill
- [ ] Full sweep: structural **N/N OK** (bundled + custom)
- [ ] `node scripts/wasm-validate-harness.mjs` → Pass = Skills count, Fail = 0
- [ ] `node scripts/spicy-error-unit-tests.mjs` → **15/15 PASS**
- [ ] No skill body over ~350 lines without auto-split (snapshot → `references/` → keep locked blocks)
- [ ] Circular deps: none (`scripts/generate-dependency-graph.py`)

## Meta triangle

- [ ] `skill-orchestrator` valid and capability v1.2 active
- [ ] `skill-creator` valid; lean publish defaults (auto + low-usage)
- [ ] `surface-parity-gate` present and valid (≤40 lines) — restore if missing

## Surface parity (chat · iOS · web)

- [ ] Layout usable at ~390px; no horizontal overflow; safe-area respected
- [ ] Primary actions ≥44px touch targets; no hover-only critical path
- [ ] Heavy panels lazy; soft-fail integrations (never block boot)
- [ ] UI/skill descriptions are plain-scalar frontmatter
- [ ] Growth language accurate: playbooks/ecosystem expanded — not “model weights updated”

## Curriculum-DPO / merge offline package (when visual/NSFW path touched)

- [ ] `artifacts/curriculum_dpo_covicea/` present
- [ ] Captions emitted (Stage 2/3 win + rejected pairs)
- [ ] `02_onetrainer_curriculum_dpo.yaml` stage ranks/LR/steps documented
- [ ] `03_dare_ties_merge_face_lock.yaml` — face weight 1.0 · DPO weight 0.6–0.8 · density ~0.70
- [ ] Local GPU handoff notes clear (ComfyUI pairs → OneTrainer → mergekit); sandbox does not claim GPU train ran

## Binaryen / wasm-opt pins (when shipping Wasm kernels)

- [ ] `config/wasm-opt-levels.toml` present (source of truth)
- [ ] `scripts/wasm-opt-pinned.sh` executable; `--print-pins` shows release=`-O3`
- [ ] Production opts use **pinned** profiles only (no freestyle `-O`)
- [ ] Gate: validate → opt → validate (WABT or Node `WebAssembly.validate`)
- [ ] wasm-pack Cargo.toml uses `wasm-opt = ["-O3"]` for release (not default `-O`)

## Lifecycle

- [ ] New skills: autonomous triggers + low-usage lean body by default
- [ ] Retires: VCS/file snapshot → `_archived/<name>/` → dep graph → re-validate (no silent wipe)
- [ ] Ownership changes logged with rationale

## Finalize stamp

- [ ] Entry in `references/performance-metrics.md` with date, counts, surfaces
- [ ] Deployment section in SKILL.md status reflects LIVE / production-ready
- [ ] User-facing report: structural · WASM · spicy · surfaces · platform wall

## Ops habit (post-ship)

**Preferred (idempotent one-shot):**
```bash
bash /home/workdir/.grok/skills/skill-orchestrator/scripts/orchestrate-finalize.sh
# Flags: --skip-vcs · --skip-stamp
```

Phases: VALIDATE (structural + WASM + spicy) → CONVERGE (create-if-absent) → SNAPSHOT → STAMP.

**Manual equivalent:**
```bash
bash /home/workdir/.grok/skills/skill-orchestrator/scripts/bulk-validate.sh
node /home/workdir/.grok/skills/skill-orchestrator/scripts/wasm-validate-harness.mjs
node /home/workdir/.grok/skills/skill-orchestrator/scripts/spicy-error-unit-tests.mjs
```

After skill-creator add or capability change → `orchestrate-finalize.sh` before calling ship done.
