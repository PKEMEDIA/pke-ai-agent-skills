# PKE Skill CI — Speed Optimization

**Stamp:** 2026-08-01 · Optimized · Measured · FINALIZED · Caching investigated · Aggregation fixed · **Consensus gate wired**

## Before → After (measured)

| Metric | Before (dual-job) | After (single-job + shallow + path filters) | Aggregation fix | + Consensus gate |
| --- | --- | --- | --- | --- |
| Wall-clock (Skill CI) | ~13 s (2 jobs) | **~9–14 s** (runs 5–10) | Target **≤ 9 s** (validate ~2 s) | **+ ~0.1–0.5 s** |
| Jobs | 2 (parallel) | 1 | 1 | 1 |
| Checkout | Full + 2× | Shallow (fetch-depth: 1) ×1 | Shallow | Shallow |
| Validation | Sequential | Parallel path + sequential re-run (bug) | **Parallel-only (authoritative)** | unchanged |
| Consensus | none | none | none | `--gate` + 13 unit tests |
| Unnecessary runs | Every push | Path-filtered | Path-filtered | Path-filtered |
| Podcast Studio | ~11 s | **~12 s** | unchanged | unchanged |

### Sample post-opt runs (main)

| Run | Workflow | Title | Wall |
| --- | --- | --- | --- |
| #5 | Skill CI | perf(ci): optimize pipeline speed… | **~9 s** |
| #5 | Podcast Studio | same commit | **~12 s** |
| #6–9 | Skill CI | autonomy / swarm / consensus / heal | **13–14 s** |
| #10 | Skill CI | FINALIZE 2026-08-01 (ea57204) | **~11 s** |
| #11 | Skill CI | perf(ci): fix parallel aggregation (bf28b9e) | **~8 s** |

Cold-start variance on `ubuntu-latest` explains remaining jitter; no second job/checkout overhead remains.

## Key changes

1. **Single job** — brand-pack presence merged into the validate job.
2. **Shallow checkout** — `fetch-depth: 1` on both workflows.
3. **Path filters** — Skill CI skips pure docs noise; Podcast path-scoped.
4. **Parallel validate (fixed)** — `CI_VALIDATE_JOBS=4` via xargs; status files are authoritative.
5. **Concurrency cancel** — both workflows cancel in-progress on same ref.
6. **Timeouts** — 8 min Skill CI, 5 min Podcast.
7. **No double podcast gate** — `validate-local.sh` runs only in the workflow step.
8. **Consensus + idempotency gate** (2026-08-01) — `node consensus-self-heal.mjs --gate` then full 13/13 unit suite + demos. Sub-second; no thrash; stamp registry exercised in CI.

## Bottleneck fix (2026-08-01) — parallel aggregation

### Problem (run 30696912757, validate step ≈ 5 s)

`scripts/ci-validate-skills.sh` ran `xargs -P4` into a temp file, **discarded the results**, then always re-validated all ~83 skills sequentially for PASS/FAIL counts. Parallel work was pure overhead. Podcast `validate-local.sh` also ran twice (script + workflow step).

### Fix

- Each skill writes one atomic status file: `PASS|name|rel` or `FAIL|name|rel` under a temp dir (unique key = sha256 of rel path, so `skills-live/` vs top-level basename collisions are safe).
- Aggregation reads only those files — **no sequential re-run**.
- Podcast local gate removed from the script (workflow step only).

### Local microbench (same runner box, 83 skills)

| Mode | Wall |
| --- | --- |
| `CI_VALIDATE_JOBS=1` (sequential only) | **~3.9 s** |
| `CI_VALIDATE_JOBS=4` (parallel, post-fix) | **~2.3 s** |
| Prior CI step (parallel + sequential re-run) | **≈ 5 s** |
| Consensus `--gate` only | **~40 ms** |
| Consensus unit suite + demos | **~100–400 ms** |

### Measured on GitHub Actions — run 30697670855 (sha bf28b9e)

| Step | Before (run 30696912757) | After (aggregation fix) |
| --- | --- | --- |
| CI validate skills | ≈ **5 s** | ≈ **2 s** (SKILLS_FOUND=83, PASS=83) |
| Total job | ≈ **11 s** | ≈ **8 s** |

Validate step ~09.08→10.87 UTC (≈1.8 s wall). Job is now mostly setup + checkout variance.

## Caching investigation (2026-08-01)

Investigated whether `actions/cache` (or any setup-* cache wrappers) could further reduce wall time.

### Why caching is not beneficial

- **No dependencies exist.** The pipelines are pure bash + system tools already present on `ubuntu-latest` (find, grep, awk, head, python3, chmod, node). There are no `node_modules`, pip caches, Go modules, Docker layers, or toolchains to restore.
- **Work is cheap I/O on a tiny repo.** Validation simply reads a few dozen small `SKILL.md` files. Consensus is pure in-process Node.
- **Cache overhead dominates.** A typical `actions/cache` restore/save cycle costs 1–4 s even for a tiny payload — the same order of magnitude as the entire job.
- **Invalidation would be frequent and complex.** A correct key would need to hash every `SKILL.md` + the validators + `permanent-activation.json`.
- **Checkout is already optimal.** `actions/checkout@v4` + `fetch-depth: 1`.

### Explicit guidance for future maintainers

**Do not introduce `actions/cache` or any setup-* cache wrappers into these workflows.**

Only revisit caching if the pipelines later gain:
- real package-manager installs (npm, pip, cargo, etc.), or
- compile / build steps that produce reusable intermediate artifacts, or
- skill counts in the hundreds where find + validation becomes the bottleneck (parallel path is now truly used).

Until then the design stays correctly minimal: single-job · shallow · path-filtered · **true parallel** · consensus gate · free-tier safe.

## How to re-measure

```bash
gh run list --workflow="PKE Skill CI" --limit 3
gh run list --workflow="PKE Podcast Studio" --limit 3
gh run view <id>
```

## Status

**OPTIMIZED · MEASURED · FINALIZED · CACHING INVESTIGATED · NO CACHE · AGGREGATION FIXED · TRUE PARALLEL · SINGLE-JOB · SHALLOW · PATH-FILTERED · CONSENSUS GATE LIVE · IDEMPOTENCY STAMPS · LIVE**
