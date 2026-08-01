# Binaryen Optimization Pipelines

**Date**: 2026-07-28  
**Binaryen version**: 131 (`version_131`)  
**Context**: skill-orchestrator WASM speed path — scalar checksum + SIMD backlog

## What Binaryen is

Compiler/toolchain library for WebAssembly. Core CLI tool: **`wasm-opt`**. Also ships `wasm-as`, `wasm-dis`, `wasm-merge`, `wasm-metadce`, `wasm-shell`, etc.

Used by Emscripten, wasm-pack, AssemblyScript, and many production Wasm pipelines as the post-compile optimizer.

## Install options (this environment)

| Method | Status | Notes |
| --- | --- | --- |
| System package / `wasmtime` | Not present | — |
| Official GitHub release tarball | Available | Linux-x86_64 builds on [releases](https://github.com/WebAssembly/binaryen/releases) |
| **npm `binaryen@131`** | **Used here** | Ships JS/Emscripten-compiled CLIs (`bin/wasm-opt`, etc.). Works under Node without native install. |
| Source (CMake + C++20) | Available | Heavier; not needed for harness work |

```bash
# Local probe path used in experiments
export PATH="/tmp/binaryen-probe/package/bin:$PATH"
wasm-opt --version   # → wasm-opt version 131
```

## Optimization levels

| Flag | Intent |
| --- | --- |
| `-O0` | No optimization |
| `-O1` | Basic |
| `-O2` | Standard |
| `-O3` | Aggressive (speed-oriented: more inlining, loop opts) |
| `-O4` | Same family as O3 (extra passes in some builds) |
| `-Os` | Size-aware |
| `-Oz` | Minimal size |
| `-O` | Alias (typically maps near O2/O3 depending on version) |

Useful modifiers:

| Flag | Effect |
| --- | --- |
| `--converge` / `-c` | Re-run until IR stops changing |
| `-tnh` | Trap-never-happen — delete paths that would trap |
| `--flatten` | Flatten control flow (enables other opts) |
| `--rereloop` | Rebuild CFG with Binaryen’s relooper |
| `--generate-global-effects` | Whole-program effect analysis |
| `--gufa` | Grand Unified Flow Analysis (constants / types) |
| `--monomorphize` | Specialize functions by call context |
| `--enable-simd` | **Required** when module uses v128 |
| `--strip-debug` / `--strip-dwarf` / `--strip-toolchain-annotations` | Strip metadata |

## Cookbook pipelines (from Binaryen Optimizer Cookbook + live tests)

### Speed (production default for compute kernels)

```bash
wasm-opt input.wasm -O3 --enable-simd -o out.wasm --strip-toolchain-annotations
```

### Size

```bash
wasm-opt input.wasm -Oz --enable-simd -o out.wasm --strip-toolchain-annotations
```

### Aggressive size (converge)

```bash
wasm-opt input.wasm -Oz --converge --enable-simd -o out.wasm --strip-toolchain-annotations
```

### Whole-program effects then size

```bash
wasm-opt input.wasm --generate-global-effects -O3 --generate-global-effects -Oz \
  --enable-simd -o out.wasm --strip-toolchain-annotations
```

### Flatten + re-rel

```bash
wasm-opt input.wasm --flatten --rereloop -Oz -Oz --enable-simd \
  -o out.wasm --strip-toolchain-annotations
```

### Trap-free aggressive

```bash
wasm-opt input.wasm -O3 -tnh --enable-simd -o out.wasm --strip-toolchain-annotations
```

## Live experiment results (skill-orchestrator harness)

### Scalar checksum module (`version` + `checksum(ptr,len)`)

| Pipeline | Size |
| --- | --- |
| Original (hand / base64) | **126 B** |
| `-O1` | 125 B |
| `-O2` / `-O3` / `-O4` / `-Os` / `-Oz` | **117 B** |
| `-Oz --converge` | **116 B** |

Control-flow was rewritten (block/loop → `if` inside loop); semantics unchanged.

### SIMD checksum module (16-byte `v128.load` + pairwise extends + scalar tail)

| Pipeline | Size |
| --- | --- |
| Raw `wasm-as` | 212 B |
| `-O3 --enable-simd` | **183 B** |
| `-Oz --converge --enable-simd` | **181 B** |

### Correctness

All test lengths (0 … 4096, including SKILL.md slice) — **scalar == SIMD** (0 mismatches).

### Throughput (1 MB buffer, 200 iterations, memory grown)

| Module | Time | Throughput |
| --- | --- | --- |
| Scalar `-O3` | 109.3 ms | ~1.9 GB/s |
| SIMD `-O3` | **24.1 ms** | **~8.7 GB/s** |

**≈ 4.5× faster** with SIMD on large buffers.

> For our current bulk skill scan (~64 × few-KB files) scalar is already ~16 ms end-to-end. SIMD matters when scanning large reference trees or multi-MB assets.

## Recommended production pipeline for this skill

```
┌─────────────┐     ┌──────────────┐     ┌─────────────────┐
│  *.wat      │ ──► │  wasm-as     │ ──► │  wasm-opt -O3   │
│  (source)   │     │  --enable-   │     │  --enable-simd  │
│             │     │  simd        │     │  --strip-…      │
└─────────────┘     └──────────────┘     └────────┬────────┘
                                                  │
                                                  ▼
                                         ┌────────────────┐
                                         │  *.wasm embed  │
                                         │  in harness    │
                                         │  (base64 or    │
                                         │   file load)   │
                                         └────────────────┘
```

1. Author kernel in WAT (scalar + optional SIMD).
2. `wasm-as kernel.wat -o kernel-raw.wasm --enable-simd`
3. `wasm-opt kernel-raw.wasm -O3 --enable-simd -o kernel.wasm --strip-toolchain-annotations`
4. Feature-detect at runtime: try SIMD module → fall back to scalar.
5. Embed optimized bytes (base64 or `fs.readFileSync`) in `wasm-validate-harness.mjs`.

## Feature detection pattern

```js
async function loadBestChecksum() {
  try {
    const simd = await WebAssembly.instantiate(simdBytes);
    // smoke test
    simd.instance.exports.checksum(0, 0);
    return { mode: "simd", exports: simd.instance.exports };
  } catch {
    const scalar = await WebAssembly.instantiate(scalarBytes);
    return { mode: "scalar", exports: scalar.instance.exports };
  }
}
```

## Passes most relevant to our kernels

- `OptimizeInstructions`, `Precompute`, `Vacuum`, `DeadCodeElimination`
- `SimplifyLocals`, `CoalesceLocals`, `CodeFolding`, `LICM`
- `MemoryPacking` (when data segments exist)
- SIMD folding happens inside `-O3` / `-Oz` when `--enable-simd` is on
- `remove-relaxed-simd` if targeting strict SIMD only

Full pass list: `wasm-opt --help`

## Artifacts from this exploration

```
/home/workdir/artifacts/binaryen-experiments/
  checksum-v1.wasm / .wat          # original scalar
  checksum-O3.wasm / .wat          # optimized scalar (117 B)
  checksum-simd-raw.wasm           # assembled SIMD
  checksum-simd-O3.wasm / .wat     # optimized SIMD (183 B)
```

## Integration status

- Documented in skill-orchestrator references.
- Scalar optimized module ready to embed.
- SIMD module verified correct + faster; optional upgrade path for harness.
- Pipeline script: `scripts/binaryen-optimize-wasm.sh` (see scripts/).

## Pass-level detail

For the full pass taxonomy, exact `-O1`/`-O2`/`-O3`/`-Os`/`-Oz` sequences (from `BINARYEN_PASS_DEBUG=1`), and per-pass roles, see:

**`references/binaryen-optimization-passes.md`**
