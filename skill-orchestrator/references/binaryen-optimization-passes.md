# Binaryen Optimization Passes — Deep Dive

**Binaryen**: 131 (`version_131`)  
**Date**: 2026-07-28  
**Source**: live `wasm-opt --help` + `BINARYEN_PASS_DEBUG=1` pipeline traces on skill-orchestrator checksum kernels

---

## How to inspect passes yourself

```bash
export PATH="/path/to/binaryen/bin:$PATH"

# All pass flags
wasm-opt --help | less

# Exact pass sequence for a level (gold)
BINARYEN_PASS_DEBUG=1 wasm-opt input.wasm -O3 -o /dev/null 2>&1 | grep "running pass:"

# Single pass
wasm-opt input.wasm --optimize-instructions -o out.wasm

# Skip a pass inside a level
wasm-opt input.wasm -O3 --skip-pass=coalesce-locals -o out.wasm

# Metrics before/after
wasm-opt input.wasm --metrics
```

**~169 named optimization / utility passes** ship in Binaryen 131.

---

## Optimization levels → pass pipelines (captured live)

### `-O1` (31 pass runs) — basic cleanup
```
duplicate-function-elimination
memory-packing
dce
remove-unused-names ×2
remove-unused-brs ×2
optimize-instructions ×2
precompute ×2
simplify-locals-nostructure
vacuum ×3
reorder-locals ×3
coalesce-locals ×2
simplify-locals
merge-blocks ×2
duplicate-function-elimination
duplicate-import-elimination
simplify-globals
remove-unused-module-elements
directize
```

### `-O2` (39 pass runs) — standard production
Adds vs O1:
- `remove-unused-module-elements` earlier
- `once-reduction`
- `pick-load-signs`
- `code-pushing`
- `rse` (redundant set elimination)
- `dae-optimizing` (dead argument elimination + optimize)
- `inlining-optimizing`
- `simplify-globals-optimizing`
- `reorder-globals`

### `-O3` (43 pass runs) — aggressive speed
Adds vs O2:
- `ssa-nomerge` (early SSA form)
- `precompute-propagate` (instead of plain precompute)
- `merge-locals`
- `local-cse`
- `code-folding`

### `-Os` (42 pass runs) — size-aware
Similar to O3 but:
- uses `precompute` (not propagate) in places
- keeps `local-cse` / `code-folding`
- slightly less aggressive propagation

### `-Oz` (44 pass runs) — minimal size
Like O3 plus:
- `merge-similar-functions` (extra size win across the module)

### `-O4`
In this build, `-O4` did not emit a distinct pass list on the tiny kernel (may alias O3 or require larger IR). Prefer explicit `-O3` or `-Oz --converge`.

---

## Pass taxonomy (practical categories)

### 1. Dead code & reachability
| Pass | Role |
| --- | --- |
| `dce` | Dead code elimination — remove unreachable instructions |
| `vacuum` | Remove obviously unneeded code (nops, empty blocks) |
| `remove-unused-brs` | Drop branches that never matter |
| `remove-unused-names` | Clean label/name noise |
| `remove-unused-module-elements` | Drop unreferenced functions/globals/types |
| `remove-unused-nonfunction-module-elements` | Same, non-function only |
| `remove-exports` / `remove-imports` | Strip interface surface |
| `once-reduction` | Collapse code that runs at most once |

### 2. Instruction & constant optimization
| Pass | Role |
| --- | --- |
| `optimize-instructions` | Peephole / algebraic simplification of Wasm ops |
| `precompute` | Fold compile-time constants |
| `precompute-propagate` | Precompute + propagate values further |
| `optimize-added-constants` | Simplify `x + c` patterns |
| `pick-load-signs` | Choose signed vs unsigned loads optimally |
| `const-hoisting` | Hoist repeated constants to locals |
| `constraint-analysis` | Infer math constraints on locals |

### 3. Locals, SSA, register pressure
| Pass | Role |
| --- | --- |
| `simplify-locals` | General local cleanup |
| `simplify-locals-nostructure` | Locals without structural CFG changes |
| `simplify-locals-notee` / `-notee-nostructure` | Variants avoiding `tee` |
| `coalesce-locals` | Reduce local count (register allocation style) |
| `coalesce-locals-learning` | Coalesce with learning heuristic |
| `merge-locals` | Merge equivalent locals |
| `reorder-locals` | Order locals for denser encoding |
| `local-cse` | Common subexpression elimination on locals |
| `ssa` / `ssa-nomerge` | Convert to SSA form |
| `rse` | Redundant set elimination |
| `untee` | Replace `local.tee` with set+get |

### 4. Control flow
| Pass | Role |
| --- | --- |
| `code-folding` | Merge duplicate code paths |
| `code-pushing` | Push code later so it may not always run |
| `merge-blocks` | Flatten consecutive blocks |
| `licm` | Loop-invariant code motion |
| `flatten` | Flatten IR (required before some passes e.g. rereloop) |
| `rereloop` | Rebuild CFG with Binaryen’s relooper |
| `remove-unused-brs` | (also listed above) |

### 5. Function / module LTO-style
| Pass | Role |
| --- | --- |
| `inlining` / `inlining-optimizing` | Inline callees (+ optimize) |
| `inline-main` | Special-case main |
| `dae` / `dae-optimizing` / `dae2` | Dead argument elimination |
| `duplicate-function-elimination` | Merge identical functions |
| `duplicate-import-elimination` | Merge duplicate imports |
| `merge-similar-functions` | Merge near-identical functions (`-Oz`) |
| `monomorphize` / `monomorphize-always` | Specialize by call context |

### 6. Globals & memory
| Pass | Role |
| --- | --- |
| `simplify-globals` / `simplify-globals-optimizing` | Fold/propagate globals |
| `reorder-globals` | Order globals for size |
| `memory-packing` | Pack active data segments |
| `heap2local` | Promote heap to locals when safe |
| `heap-store-optimization` | Optimize heap stores |
| `instrument-memory` | Debug instrumentation |

### 7. SIMD / features
| Pass | Role |
| --- | --- |
| `--enable-simd` | Feature flag (not a pass) — required for v128 |
| `remove-relaxed-simd` | Lower/replace relaxed SIMD ops |
| (inside `-O3`) | SIMD folding happens via `optimize-instructions` + related |

### 8. Types / GC / references (heavier modules)
| Pass | Role |
| --- | --- |
| `gufa` / `gufa-optimizing` / `gufa-cast-all` | Grand Unified Flow Analysis |
| `type-refining` / `type-refining-gufa` | More specific subtypes |
| `type-merging` / `type-ssa` / `type-finalizing` | Type graph cleanup |
| `cfp` / `cfp-reftest` | Constant field propagation |
| `abstract-type-refining` | Merge never-created abstract types |

### 9. Strip / legalize / lower
| Pass | Role |
| --- | --- |
| `strip-debug` / `strip-dwarf` / `strip-producers` | Remove debug metadata |
| `strip-toolchain-annotations` | Remove `@binaryen.*` hints |
| `strip-target-features` | Drop target features section |
| `legalize-js-interface` | JS-friendly imports/exports |
| `i64-to-i32-lowering` / `signext-lowering` / `memory64-lowering` | ABI lowers |
| `asyncify` | Async/await transform for pause/resume |

### 10. Analysis / debug (usually not in -On)
| Pass | Role |
| --- | --- |
| `metrics` | Print IR metrics |
| `print` / `print-full` / `print-minified` | Dump IR |
| `print-call-graph` / `func-metrics` | Structure reports |
| `nm` | Symbol list |
| `generate-global-effects` | Effect analysis for later opts |

---

## What actually mattered on our kernels

### Scalar checksum (126 B → 117 B at `-O2`+)

Individual passes alone rarely shrink this tiny loop (some even +1 B from encoding). The **pipeline** wins by:

1. Rewriting `block + loop + br_if` into `loop + if + br`
2. Reordering adds (`load` then add into sum)
3. Dropping redundant names / vacuuming

Key contributors visible in the O2/O3 traces:
`optimize-instructions`, `precompute` / `precompute-propagate`, `simplify-locals*`, `coalesce-locals`, `code-pushing`, `merge-blocks`, `remove-unused-brs`, `vacuum`, `rse`.

### SIMD checksum (212 B → 181–183 B)

Most single passes were neutral; **`simplify-locals` (−6 B)** and **`local-cse` (−1 B)** helped alone. Full `-O3 --enable-simd` packs pairwise extends and extract lanes more tightly.

Metrics on SIMD-O3:
- 57 IR nodes, 4 SIMDExtract, 2 Loads, 2 Loops, 4 Vars

---

## Practical recipes for skill-orchestrator

```bash
# Default speed kernel
wasm-opt kernel.wasm -O3 --enable-simd \
  --strip-toolchain-annotations -o kernel-O3.wasm

# Size
wasm-opt kernel.wasm -Oz --converge --enable-simd \
  --strip-toolchain-annotations -o kernel-Oz.wasm

# Debug which passes fire
BINARYEN_PASS_DEBUG=1 wasm-opt kernel.wasm -O3 -o /dev/null

# Custom: O3 without inlining (keep function boundaries for profiling)
wasm-opt kernel.wasm -O3 --skip-pass=inlining-optimizing \
  --enable-simd -o kernel-noinline.wasm

# Flatten → rereloop (only if you need CFG rebuild)
wasm-opt kernel.wasm --flatten --rereloop -O3 --enable-simd -o kernel-reloop.wasm
```

Or use the packaged script:
```bash
bash skill-orchestrator/scripts/binaryen-optimize-wasm.sh kernel.wat ./out
```

---

## Pass ordering principles (why levels re-run passes)

Binaryen intentionally runs several passes **multiple times** (e.g. `vacuum`, `optimize-instructions`, `coalesce-locals`, `remove-unused-brs`):

1. Early passes expose opportunities (DCE, precompute).
2. Mid passes reshape locals/CFG (simplify, coalesce, fold).
3. Late passes clean up after inlining / DAE (vacuum, DCE again, reorder).

That is why a single `--vacuum` on raw IR barely helps, but vacuum inside `-O3` matters.

---

## Related references in this skill

- `references/binaryen-optimization-pipeline.md` — levels, cookbook, size/throughput tables
- `references/wasi-and-simd-notes.md` — WASI + SIMD feature path
- `scripts/binaryen-optimize-wasm.sh` — one-shot assemble + O3 + Oz-converge

---

## Quick map: goal → passes

| Goal | Prefer |
| --- | --- |
| Smaller download | `-Oz --converge`, `merge-similar-functions`, strip-* |
| Faster loops / SIMD | `-O3`, `precompute-propagate`, `local-cse`, `licm`, `code-folding` |
| Fewer locals | `coalesce-locals`, `merge-locals`, `simplify-locals` |
| Kill dead API surface | `remove-unused-module-elements`, `dae-optimizing` |
| JS interop | `legalize-js-interface`, `optimize-for-js` |
| Understand IR | `BINARYEN_PASS_DEBUG=1`, `--metrics`, `--print` |
