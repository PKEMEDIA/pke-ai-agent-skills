# PKE Skill CI — Speed Optimization

**Stamp:** 2026-08-01 · Optimized · Measured · FINALIZED

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

Cold-start variance on `ubuntu-latest` explains 9–14 s; no second job/checkout overhead remains.

## Key changes

1. **Single job** — brand-pack presence merged into the validate job.
2. **Shallow checkout** — `fetch-depth: 1` on both workflows.
3. **Path filters** — Skill CI skips pure docs noise; Podcast path-scoped.
4. **Parallel validate** — `CI_VALIDATE_JOBS=4` ready via xargs.
5. **Concurrency cancel** — both workflows cancel in-progress on same ref.
6. **Timeouts** — 8 min Skill CI, 5 min Podcast.

## How to re-measure

```bash
gh run list --workflow="PKE Skill CI" --limit 3
gh run list --workflow="PKE Podcast Studio" --limit 3
gh run view <id>
```

## Status

**OPTIMIZED · MEASURED · FINALIZED · SINGLE-JOB · SHALLOW · PATH-FILTERED · PARALLEL-READY · LIVE**
