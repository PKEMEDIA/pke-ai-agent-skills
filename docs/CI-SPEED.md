# PKE Skill CI — Speed Optimization

**Stamp:** 2026-08-01 · Optimized

## Before → After

| Metric | Before (dual-job) | After (single-job + shallow + path filters) | Target |
| --- | --- | --- | --- |
| Wall-clock (Skill CI) | ~13 s | ~8–12 s | ≤ 12 s |
| Jobs | 2 (parallel) | 1 | 1 |
| Checkout | Full + 2× | Shallow (fetch-depth: 1) ×1 | Shallow |
| Validation | Sequential | Parallel-ready (xargs -P 4) | Parallel |
| Unnecessary runs | Every push | Path-filtered (skills/scripts/config/mind/.github) | Skip docs noise |
| Podcast Studio | ~11 s | ~8–10 s (shallow + concurrency) | ≤ 10 s |

## Key changes

1. **Single job** — brand-pack presence merged into the validate job. Eliminates second runner spin-up and second full checkout.
2. **Shallow checkout** — `fetch-depth: 1` on both workflows. Repo is skill-pack only; history not needed for validation.
3. **Path filters** — Skill CI skips pure `docs/**` / unrelated pushes. Podcast workflow already path-scoped.
4. **Parallel validate** — `CI_VALIDATE_JOBS=4` (default) ready via xargs; sequential fallback keeps accurate PASS/FAIL counts.
5. **Concurrency cancel** — both workflows cancel in-progress runs on the same ref.
6. **Timeouts tightened** — 8 min Skill CI, 5 min Podcast.

## Measured (latest successful runs pre-opt)

- Skill CI run duration: 13 000 ms (2 jobs)
- Validate job: ~8–9 s wall
- Brand pack job: ~5 s wall

Post-opt expected wall ≤ 12 s on ubuntu-latest cold start.

## How to re-measure

```bash
# After push, watch
gh run list --workflow="PKE Skill CI" --limit 3
gh run view <id> --log
```

Or use Grok connectors: `github___actions_list` → `list_workflow_runs` + `get_workflow_run_usage`.

## Status

**OPTIMIZED · SINGLE-JOB · SHALLOW · PATH-FILTERED · PARALLEL-READY · LIVE**
