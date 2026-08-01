---
name: skill-orchestrator
description: Orchestrate, validate, optimize, polish, and continuously improve the full Grok skill ecosystem. Use for full skill testing, trigger broadening, limit reduction, autonomy enhancement, agent coordination meetings, dependency mapping, performance troubleshooting, ecosystem health checks, finalizing skills, capability expansion, auto-split, auto-run Curriculum-DPO scaffolds and merge configs, managed skill archive, ownership updates, or deploying polished skills across chat, app, and web. Triggers on orchestrate skills, skill orchestrator, run full skill test, validate and optimize skills, fix grok limits, skill maintenance, agent meeting, polish skills, continuous testing, finalize and deploy skill, finalize optimize polish deploy, make skills more autonomous, improve skill system, expand capabilities, auto-split skill, run DPO scaffold, archive skill, or any request to audit, heal, or strengthen the overall skill library.
---

# Skill Orchestrator

Meta-skill for health, efficiency, **autonomy**, and continuous improvement of the full Grok skill system (bundled `/root/.grok/skills/` + custom `/home/workdir/.grok/skills/`).

Handles structural validation, trigger optimization, limit reduction, agent coordination, performance benchmarking, dependency mapping, WASM bulk checks, **self-healing with expanded auto-actions**, Curriculum-DPO offline pipeline, managed skill lifecycle, and capability expansion.

## Core Principles
- **Local & Tool-First**: Prefer bash, read_file/edit_file, parallel calls. Confirm sandbox execution first.
- **Permanent Changes**: Edit/create in `/home/workdir/.grok/skills/` for persistence and instant app/web inheritance.
- **Progressive Disclosure**: Keep SKILL.md lean. Details live in `references/`. Load on demand.
- **Maximize Autonomy**: Auto-execute every action the sandbox and skill layer allow. Do not hide behind “proposal only” when scripts and edits can finish the job.
- **Honest Platform Wall**: Cannot change Grok foundation weights or SuperGrok quotas. **Can** expand playbooks, adapters configs, DPO scaffolds, ownership maps, and synthetic-intelligence loops so the *ecosystem* learns daily.
- **Safety with Power**: Snapshot before destructive-ish moves. Preserve locked phenotype + legal operative text. Log everything.
- **Continuous Loop**: validate → diagnose → fix → re-test → report until pass or clear remaining platform walls.

## Capability Reality (expanded July 28, 2026 19:20 EDT)

| Area | Status | What orchestrator does |
| --- | --- | --- |
| Foundation weights / quotas | **Platform wall** | Cannot write weights or quotas. Routes growth into playbooks, DPO offline path, merge configs, metrics. |
| Auto-split oversized skills | **ENABLED** | VCS/file snapshot → move verbose sections to `references/` → keep locked blocks → re-validate. |
| Locked identity / legal core text | **Protected rewrite** | Auto-split around them; rewrite of core phenotype or legal operative language only on explicit user intent. |
| Curriculum-DPO + merges | **ENABLED (offline path)** | Auto-run `scaffold_dpo_pairs.py`, emit captions/manifests, write DARE-TIES / role-seeded merge YAMLs, hand off image-pair step to local-nsfw-comfyui. |
| Skill delete / retire | **ENABLED (managed)** | Snapshot → archive under `_archived/` → update dep graph → re-validate. No silent wipe. |
| Ownership hierarchy | **ENABLED (logged)** | Update cross-refs + graph with rationale; re-validate. |
| Growth language | **ENABLED (accurate)** | Say skills/playbooks/ecosystem learned or expanded. Do not claim foundation weights changed. |

Full diagnosis + procedures: `references/capability-expansion.md`.


## Grok Build / iOS ecosystem notes
- Include `grok-build-assistant` in Build-related coordination meetings.
- iOS users often cannot complete custom MCP (SuperCool); health checks must not assume live SuperCool tools.
- Prefer progressive disclosure so Build + chat sessions stay within practical context limits.
- After adding Build-oriented skills, re-validate and update dependency notes.

## Workflow (execute in order)

### 1. Discovery & Inventory
- List bundled + custom skills; name, path, line count, description summary.
- Flag missing SKILL.md, malformed dirs, newly added, archive candidates.
- Update inventory notes when state changes materially.

### 2. Structural Validation & Auto-Fix
- `bash /root/.grok/skills/skill-creator/scripts/validate-skill.sh "<path>"` on every skill.
- On FAIL: diagnose, `edit_file` fix, re-validate (max 3 attempts per skill).
- Fast path: `node scripts/wasm-validate-harness.mjs`.
- Full: `bash scripts/bulk-validate.sh`.

### 3. Autonomy & Trigger Optimization
- Broaden narrow frontmatter descriptions with synonyms and natural phrasings.
- Re-validate affected skills.

### 4. Agent Coordination Meeting
- Select 4–6 relevant skills; read in parallel; synthesize; apply edits.
- See `references/agent-meeting-protocol.md`.

### 5. Performance & Auto-Split
- Flag bodies approaching ~350–500 lines or redundant sections.
- **Auto-split** (enabled): snapshot → offload to `references/` → keep locked blocks → re-validate.
- See `references/limit-optimization.md` + `references/capability-expansion.md`.

### 6. Curriculum-DPO & Merge Auto-Pipeline
- On recurring anatomy/skin/identity fails or explicit request:
  - Run `python scripts/scaffold_dpo_pairs.py init|captions|manifest`
  - Emit merge YAML (dare_ties / style→face→DPO / role-seeded)
  - Write artifacts; log handoff for local ComfyUI pair images + OneTrainer
- See `references/curriculum-dpo-nsfw.md` and stage templates.

### 7. Skill Lifecycle & Ownership
- Retire/archive on request: snapshot → `_archived/<name>/` → dep graph → validate.
- Ownership updates: logged cross-ref + graph rewrite.

### 8. Continuous Test-Fix Loop
- Max 5 iterations (or user-specified). Exit on full pass or remaining **platform walls** only.
- Log in `/home/workdir/artifacts/` and `references/performance-metrics.md`.

### 9. Persist & Confirm
- All fixes in user-dir copies. Re-validate every modified skill.
- Confirm: structurally OK, autonomy-enhanced, capability-expanded, ready for chat / iOS / web.

## Speed & Quality Tooling (scripts/)

| Script | Purpose |
| --- | --- |
| `orchestrate-finalize.sh` | **Idempotent Finalize apply** — validate → converge → snapshot → stamp |
| `bulk-validate.sh` | Official validate-skill.sh over all skills + WASM harness |
| `wasm-validate-harness.mjs` | WASM v1 structural/integrity scan |
| `spicy-error-unit-tests.mjs` | 15 unit tests for spicy error classification + recovery |
| `binaryen-optimize-wasm.sh` | Binaryen -O3 / -Oz pipeline |
| `wasm-opt-pinned.sh` | **Pinned v1.1** (`release=-O3+strip`, `ios=-Oz --converge+full strip`) |
| `generate-dependency-graph.py` | Cross-ref graph, clusters, circular-dep check, Mermaid |
| `continuous-testing-loop.sh` | Automated iterate-and-log loop |
| `bisect-skill.sh` / `skill-vcs.sh` | Bisect + snapshots (required before archive/split) |
| `scaffold_dpo_pairs.py` | **Auto-run** Curriculum-DPO pair folders, captions, manifest |

## References (load on demand)
- `references/capability-expansion.md` — **why limits existed + how they are fixed**
- `references/self-healing-protocol.md` — detection + expanded auto-remediation
- `references/activation-and-autonomy.md` — trigger templates
- `references/limit-optimization.md` — token/refactor patterns
- `references/agent-meeting-protocol.md` — multi-skill consultation
- `references/continuous-testing-loop.md` — iteration + report formats
- `references/dependency-graph.md` / `.mmd` — current map
- `references/performance-metrics.md` — benchmarks and cycle logs
- `references/curriculum-dpo-nsfw.md` — 3-stage Curriculum-DPO strategy
- `references/curriculum-dpo-stage2-templates.md` / `stage3-templates.md`
- `references/automated-pair-scoring.md` — hybrid reward pair generation
- `references/spicy-mode-setup-and-interface.md` — Spicy enable checklist, iOS↔web troubleshooting, recovery cross-link
- `references/deployment-checklist.md` — **ship gate** for chat · iOS · web Finalize
- `references/wasm-opt-levels.md` — **pinned** Binaryen profiles (`config/wasm-opt-levels.toml`)
- `references/wasi-and-simd-notes.md` / `binaryen-optimization-*.md`

## Ecosystem Health — CAPABILITY EXPANSION July 28, 2026 19:20 EDT

| Metric | Value |
| --- | --- |
| Mode | **Expanded autonomy** (auto-split, auto-DPO scaffold, managed archive) |
| Platform wall | Foundation weights + quotas only |
| Structural target | 100% OK after every change |
| Key sequence | pretty-kitty-model-management → covicea-brand-assistant → paralegal-assistant |
| Voice handoff | voice-reference-protocol → rvc-voice-production |
| Curriculum-DPO | Auto-scaffold live via `scaffold_dpo_pairs.py` |

## Deployment Checklist (chat · iOS · web)

Run before **Finalize**. Full detail: `references/deployment-checklist.md`.

| Gate | Pass criteria |
| --- | --- |
| Structural | Every skill `validate-skill.sh` OK · full N/N |
| WASM | `wasm-validate-harness.mjs` Fail = 0 |
| Spicy | `spicy-error-unit-tests.mjs` **15/15** |
| Bodies | No SKILL.md ≳350 lines without auto-split |
| Meta | orchestrator · creator · `surface-parity-gate` present |
| Surfaces | ~390px OK · ≥44px touch · soft-fail integrations |
| Growth language | Playbooks/ecosystem expanded — not foundation weights |
| DPO package (if visual) | Captions + OneTrainer YAML + DARE-TIES 0.6–0.8 |
| Wasm opt pins | v1.1 · release=`-O3 --strip-toolchain-annotations` · ios=`-Oz --converge`+strip |
| Stamp | `performance-metrics.md` entry + LIVE status |

**Status**: LIVE · capability-expanded · wasm-opt pins deployed · self-heal executes (not only proposes) · VCS graceful non-git.  
Persistent under `/home/workdir/.grok/skills/`. Inherited by chat, iOS app, web.  
**Ops**: after skill-creator add or capability change → `bash scripts/bulk-validate.sh` + WASM + spicy tests.  
**Wasm kernels**: `scripts/wasm-opt-pinned.sh` (never freestyle `-O` flags).  
**Finalize**: `bash scripts/orchestrate-finalize.sh` (VALIDATE → CONVERGE → SNAPSHOT → STAMP).

## Synthetic Intellect (autonomous · free-tier)

```bash
bash /home/workdir/.grok/skills/skill-orchestrator/scripts/pke-learn.sh          # observe → heal → improve → stamp
bash /home/workdir/.grok/skills/skill-orchestrator/scripts/pke-learn.sh --push   # + sync improvements to GitHub
```

- Runs **locally only** — no Imagine, no video, no SuperGrok burn.
- Learns from heal logs, validate fails, asset gates, and skill text gaps.
- Writes lessons to `artifacts/pke-mind/` and may patch skill docs.
- Always self-heal before applying improvements.
- Safe on free tier forever; cloud gen is optional user action only.
