# PKE Skill CI — Speed Optimization

**Stamp:** 2026-08-01 · Optimized · Measured · FINALIZED · Caching investigated

## Before → After (measured)

| Metric | Before (dual-job) | After (single-job + shallow + path filters) | Measured |
| --- | --- | --- | --- |
| Wall-clock (Skill CI) | ~13 s (2 jobs) | Target ≤ 12 s | **~9–14 s** (runs 5–9) |
| Jobs | 2 (parallel) | 1 | 1 |
| Checkout | Full + 2× | Shallow (fetch-depth: 1) ×1 | Shallow |
| Validation | Sequential | Parallel-ready (xargs -P 4) | Live |
| Unnecessary runs | Every push | Path-filtered | Skip pure docs noise |
| Podcast Studio | ~11 s | Target ≤ 10–12 s | **~12 s** |

### Sample post-opt runs (main)

| Run | Workflow | Title | Wall |
| --- | --- | --- | --- |
| #5 | Skill CI | perf(ci): optimize pipeline speed… | **~9 s** |
| #5 | Podcast Studio | same commit | **~12 s** |
| #6–9 | Skill CI | autonomy / swarm / consensus / heal | **13–14 s** |
| #10 | Skill CI | FINALIZE 2026-08-01 (ea57204) | **~11 s** |

Cold-start variance on `ubuntu-latest` explains 9–14 s; no second job/checkout overhead remains.

## Key changes

1. **Single job** — brand-pack presence merged into the validate job.
2. **Shallow checkout** — `fetch-depth: 1` on both workflows.
3. **Path filters** — Skill CI skips pure docs noise; Podcast path-scoped.
4. **Parallel validate** — `CI_VALIDATE_JOBS=4` ready via xargs.
5. **Concurrency cancel** — both workflows cancel in-progress on same ref.
6. **Timeouts** — 8 min Skill CI, 5 min Podcast.

## Caching investigation (2026-08-01)

Investigated whether `actions/cache` (or any setup-* cache wrappers) could further reduce wall time.

### Measured step times — Skill CI run 30696912757 (sha ea57204)

| Step | Duration |
| --- | --- |
| Set up job | ≈ 1 s |
| Checkout (shallow) | ≈ 1 s |
| Make scripts executable | < 1 s |
| CI validate skills (parallel) | ≈ 5 s |
| Podcast studio local gate | < 1 s |
| Brand pack + permanent activation stamps | ≈ 1 s |
| Upload + post-checkout | < 1 s |
| **Total job** | **~11 s** |

### Why caching is not beneficial

- **No dependencies exist.** The pipelines are pure bash + system tools already present on `ubuntu-latest` (find, grep, awk, head, python3, chmod). There are no `node_modules`, pip caches, Go modules, Docker layers, or toolchains to restore.
- **Work is cheap I/O on a tiny repo** (~1.1 MB total). Validation simply reads a few dozen small `SKILL.md` files. The useful work itself is only ~5 s.
- **Cache overhead dominates.** A typical `actions/cache` restore/save cycle costs 1–4 s even for a tiny payload — the same order of magnitude as the entire job. On miss (any real skill change) you pay the cost for zero gain.
- **Invalidation would be frequent and complex.** A correct key would need to hash every `SKILL.md` + the validators + `permanent-activation.json`. Exactly the changes CI must catch would invalidate the cache.
- **Checkout is already optimal.** `actions/checkout@v4` + `fetch-depth: 1` is the right choice; further git-object or sparse tricks add complexity with no measurable win.

### Explicit guidance for future maintainers

**Do not introduce `actions/cache` or any setup-* cache wrappers into these workflows.**

Only revisit caching if the pipelines later gain:
- real package-manager installs (npm, pip, cargo, etc.), or
- compile / build steps that produce reusable intermediate artifacts, or
- skill counts in the hundreds where find + sequential validation becomes the bottleneck (the parallel path is already prepared).

Until then the design stays correctly minimal: single-job · shallow · path-filtered · parallel-ready · free-tier safe.

## How to re-measure

```bash
gh run list --workflow="PKE Skill CI" --limit 3
gh run list --workflow="PKE Podcast Studio" --limit 3
gh run view <id>
```

## Status

**OPTIMIZED · MEASURED · FINALIZED · CACHING INVESTIGATED · NO CACHE · SINGLE-JOB · SHALLOW · PATH-FILTERED · PARALLEL-READY · LIVE**
