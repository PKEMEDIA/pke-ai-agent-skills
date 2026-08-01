# WASI & WASM SIMD — Investigation Notes

**Date**: 2026-07-28  
**Context**: skill-orchestrator speed path follow-up (items 5–6)

## WebAssembly System Interface (WASI)

### What it is
WASI is a modular system-interface standard so Wasm modules can do file I/O, clocks, random, and args/env without depending on a browser or a specific JS host. Preview1 (`wasi_snapshot_preview1`) is the widely implemented snapshot.

### Availability in this environment
| Surface | Status |
| --- | --- |
| `node:wasi` | **Available** (experimental warning) |
| Preview | `preview1` |
| Import object | `wasi_snapshot_preview1` present with full fn set |
| External runtimes (`wasmtime`, `wasmer`) | Not installed in sandbox |

### When to use WASI here
- **Good fit**: Portable `.wasm` CLI validators shipped outside Node (e.g. desktop skill-lint binary, CI without Node).
- **Not needed now**: The bulk validate harness already uses Node `fs` + `Promise.all` and finishes the full 64-skill scan in ~10–15 ms. WASI would add startup and capability ceremony without a latency win inside Node.

### Recommendation
Keep the Node harness as primary. Add a WASI-target build only if we publish a standalone `skill-validate.wasm` for non-Node hosts. Prototype path:

```js
import { WASI } from 'node:wasi';
const wasi = new WASI({
  version: 'preview1',
  args: process.argv,
  env: process.env,
  preopens: { '/skills': '/home/workdir/.grok/skills' },
});
// compile module that imports wasi_snapshot_preview1 → wasi.start(instance)
```

## WASM SIMD

### Goal
Vectorize integrity checksums / byte scans over large SKILL.md batches.

### Findings
- V8 **13.6** (this Node) supports SIMD when given well-formed Wasm binaries.
- Hand-assembled SIMD test modules are fragile; **wat2wasm / Binaryen** is the reliable path.
- Current scalar `checksum(ptr,len)` over Wasm memory already covers 64 skills in ~12 ms — SIMD would matter more at hundreds of skills or multi-MB reference files.

### Recommended SIMD path (validated 2026-07-28)
1. Author kernel in WAT (`v128.load` + `i16x8.extadd_pairwise_i8x16_u` + scalar tail).
2. Assemble + optimize with **Binaryen** (preferred over hand-bytes):
   ```bash
   wasm-as checksum-simd.wat -o raw.wasm --enable-simd
   wasm-opt raw.wasm -O3 --enable-simd -o checksum-simd.wasm --strip-toolchain-annotations
   ```
   Or use `scripts/binaryen-optimize-wasm.sh`.
3. Feature-detect at runtime: try SIMD module → fall back to scalar.
4. Benchmarked: **~4.5×** faster than scalar-O3 on 1 MB buffers (~8.7 vs ~1.9 GB/s). Correctness matched on all tested lengths.

### Binaryen pipeline (full notes)
See **`references/binaryen-optimization-pipeline.md`** for levels, cookbook commands, live size tables, and integration status.

### Current production choice
**Scalar Wasm checksum + JS structural rules + optional WASI probe flags.** Portable, tested, fast enough for 64-skill scans (~16 ms). SIMD module is verified and available as an optional upgrade via Binaryen pipeline; enable when scanning large reference trees.

## Harness flags
```bash
node scripts/wasm-validate-harness.mjs --probe-wasi --probe-simd \
  --json /home/workdir/artifacts/validation-report.json
```

## Unit tests
Spicy error protocol: `scripts/spicy-error-unit-tests.mjs`  
Run after any edit to the Error Handling section of `spicy-male-erotic-prompt-optimizer`.
