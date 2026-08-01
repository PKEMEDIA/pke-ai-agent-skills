---
name: skill-orchestrator
description: Orchestrate, validate, optimize, polish, and continuously improve the full Grok skill ecosystem. Use for full skill testing, trigger broadening, limit reduction, autonomy enhancement, agent coordination meetings, dependency mapping, performance troubleshooting, ecosystem health checks, finalizing skills, capability expansion, auto-split, auto-run Curriculum-DPO scaffolds and merge configs, managed skill archive, ownership updates, or deploying polished skills across chat, app, and web. Triggers on orchestrate skills, skill orchestrator, run full skill test, validate and optimize skills, fix grok limits, skill maintenance, agent meeting, polish skills, continuous testing, finalize and deploy skill, finalize optimize polish deploy, make skills more autonomous, improve skill system, expand capabilities, auto-split skill, run DPO scaffold, archive skill, or any request to audit, heal, or strengthen the overall skill library.
---

# Skill Orchestrator

Meta-skill for health, efficiency, **autonomy**, and continuous improvement of the full Grok skill system.

**Live trees (priority order on this Mac):**
1. `~/.grok/skills/` — Grok Build CLI (symlinks into this repo)
2. `~/PKE/pke-ai-agent-skills/skills-live/` — grok.com user-skill mirror (50+)
3. Sandbox when present — `/root/.grok/server-skills/`, `/home/workdir/.grok/skills/`, `/workspace/.grok/skills/`

Handles structural validation, trigger optimization, limit reduction, agent coordination, performance benchmarking, dependency mapping, WASM bulk checks, **self-healing with expanded auto-actions**, Curriculum-DPO offline pipeline, managed skill lifecycle, and capability expansion.

## Core Principles
- **Local & Tool-First**: Prefer bash, read_file/edit_file, parallel calls. Confirm execution environment first.
- **Permanent Changes**: Edit in this repo (`pke-ai-agent-skills`) and keep CLI links under `~/.grok/skills/`. In chat sandboxes, prefer `/home/workdir/.grok/skills/`.
- **Progressive Disclosure**: Keep SKILL.md lean. Details live in `references/`. Load on demand.
- **Maximize Autonomy**: Auto-execute every action the host allows. Do not hide behind “proposal only” when scripts and edits can finish the job.
- **Honest Platform Wall**: Cannot change Grok foundation weights or SuperGrok quotas. **Can** expand playbooks, adapters configs, DPO scaffolds, ownership maps, and synthetic-intelligence loops so the *ecosystem* learns daily.
- **Safety with Power**: Snapshot before destructive-ish moves. Preserve locked phenotype + legal operative text. Log everything.
- **Continuous Loop**: validate → diagnose → fix → re-test → report until pass or clear remaining platform walls.

## Capability Reality (expanded Aug 1, 2026)

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
- Mac CLI: `bash scripts/bulk-validate-mac.sh` (PKE gate + WASM + spicy).
- Single skill: `bash skill-creator/scripts/validate-skill.sh "<path>"` (or `~/.grok/skills/skill-creator/...`).
- On FAIL: diagnose, fix, re-validate (max 3 attempts per skill).
- Fast path: `node scripts/wasm-validate-harness.mjs --root <skills-dir>`.
- Sandbox full: `bash scripts/bulk-validate.sh`.

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
- Log in `artifacts/` (repo or sandbox) and `references/performance-metrics.md`.

### 9. Persist & Confirm
- Commit fixes in this repo; re-link `~/.grok/skills/` if needed. Re-validate every modified skill.
- Confirm: structurally OK, autonomy-enhanced, capability-expanded, ready for chat / iOS / web / CLI.

## Speed & Quality Tooling (scripts/)

| Script | Purpose |
| --- | --- |
| `orchestrate-finalize.sh` | **Idempotent Finalize** — validate → converge → snapshot → stamp |
| `bulk-validate-mac.sh` | **Mac host** PKE gate (skills-live + repo-root) + CLI + WASM + spicy |
| `bulk-validate.sh` | Sandbox paths + WASM harness |
| `wasm-validate-harness.mjs` | WASM v1 structural/integrity scan (`--root` supported) |
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

## Ecosystem Health (measured Aug 1, 2026)

| Metric | Value |
| --- | --- |
| Mode | **Expanded autonomy** (auto-split, auto-DPO scaffold, managed archive) |
| Platform wall | Foundation weights + quotas only |
| skills-live structural | **52/52 OK** |
| WASM harness | **52/52** · ~46–54 ms · wasm v1 |
| Spicy unit tests | **15/15 PASS** |
| grok.com user-skills | **50/50** mirrored in skills-live |
| Key sequence | pretty-kitty-model-management → covicea-brand-assistant → paralegal-assistant |
| Curriculum-DPO | Auto-scaffold via `scaffold_dpo_pairs.py` |

## Deployment Checklist (chat · iOS · web · CLI)

Run before **Finalize**. Full detail: `references/deployment-checklist.md`.

| Gate | Pass criteria |
| --- | --- |
| Structural | `validate-skill.sh` OK on PKE trees · full N/N |
| WASM | `wasm-validate-harness.mjs --root skills-live` Fail = 0 |
| Spicy | `spicy-error-unit-tests.mjs` **15/15** |
| Bodies | No SKILL.md ≳350 lines without auto-split |
| Meta | orchestrator · creator live under `~/.grok/skills/` |
| Surfaces | chat · iOS · web · Grok Build CLI |
| Growth language | Playbooks/ecosystem expanded — not foundation weights |
| Stamp | `performance-metrics.md` entry + LIVE status |

**Status**: **LIVE · POLISHED · DEPLOYED** (Mac CLI + skills-live + GitHub source).  
**Primary Mac live path**: `~/.grok/skills/skill-orchestrator` → this package.  
**Ops (Mac)**: `bash ~/.grok/skills/skill-orchestrator/scripts/bulk-validate-mac.sh`  
**Ops (sandbox)**: `bash scripts/bulk-validate.sh` + WASM + spicy.  
**Wasm kernels**: `scripts/wasm-opt-pinned.sh` only.  
**Finalize**: `bash scripts/orchestrate-finalize.sh` (sandbox) or Mac bulk-validate + stamp.

## Synthetic Intellect (autonomous · free-tier)

```bash
bash ~/.grok/skills/skill-orchestrator/scripts/pke-learn.sh          # observe → heal → improve → stamp
bash ~/.grok/skills/skill-orchestrator/scripts/pke-learn.sh --push   # + sync to GitHub
```

- Runs **locally only** — no Imagine, no video, no SuperGrok burn.
- Learns from heal logs, validate fails, asset gates, and skill text gaps.
- Always self-heal before applying improvements.
- Safe on free tier forever; cloud gen is optional user action only.

## GitHub Autonomy (PKEMEDIA/pke-ai-agent-skills)
- Source of truth for perfected skills, mind cycles, and CI.
- After healthy PKE bulk-validate, sync via `pke-learn.sh --push` or `git push`.
- Never push secrets, private legal case details, or credentials.
- Companion skill: `autonomous-ecosystem`.

## Last orchestration stamp
**2026-08-01 10:50 EDT — Polish & deploy (Mac CLI):** skill-orchestrator LIVE under `~/.grok/skills/`; bulk-validate-mac.sh added; skills-live 52/52 + WASM 52/52 + spicy 15/15; grok.com 50/50 cross-check green; Mac paths documented as primary host.

## SI Kernel runtime
- Pair with **si-kernel** (`si` binary · `~/.agent-os`) for local drain/MCP.
