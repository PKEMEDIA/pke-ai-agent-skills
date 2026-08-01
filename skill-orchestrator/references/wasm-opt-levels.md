# Pinned wasm-opt optimization levels (v1.1)

**Source of truth:** `config/wasm-opt-levels.toml`  
**Apply script:** `scripts/wasm-opt-pinned.sh`  
**Pinned:** 2026-07-28 · **v1.1.0** (optimized flags)

`wasm-opt` is **Binaryen** (not WABT). Always **validate → opt → validate**.

## What changed in v1.1

| Change | Why |
| --- | --- |
| `--strip-toolchain-annotations` on all ship profiles | Drop Binaryen metadata; cleaner ship binary |
| Size / iOS: also `--strip-debug --strip-dwarf --strip-producers` | Smaller mobile payloads when sections exist |
| New profile `ios` | Explicit alias of `release_size` |
| `WASM_OPT_SIMD=1` | Append `--enable-simd` only when module needs v128 |

## Pins

| Profile | Args | When |
| --- | --- | --- |
| `dev` | *(skip)* | Local iteration |
| `speed` / **`release`** | `-O3 --strip-toolchain-annotations` | **Default ship** |
| `size` | `-Oz` + strip annotations + debug/dwarf/producers | Payload-bound |
| `size_balanced` | `-Os --strip-toolchain-annotations` | Moderate size |
| `release_converge` | `-O3 --converge --strip-toolchain-annotations` | Fixed-point speed |
| **`release_size` / `ios`** | `-Oz --converge` + full strip | **iOS / max size** |

## Commands

```bash
./scripts/wasm-opt-pinned.sh --print-pins
./scripts/wasm-opt-pinned.sh in.wasm out.wasm                    # release
./scripts/wasm-opt-pinned.sh in.wasm out.wasm --profile ios      # iOS size
WASM_OPT_SIMD=1 ./scripts/wasm-opt-pinned.sh in.wasm out.wasm    # + SIMD
```

## wasm-pack

```toml
[package.metadata.wasm-pack.profile.release]
wasm-opt = ["-O3", "--strip-toolchain-annotations"]
```

## Related

- `binaryen-optimization-passes.md` — pass taxonomy  
- `binaryen-optimization-pipeline.md` — cookbook recipes  
- `binaryen-optimize-wasm.sh` — dual O3 / Oz-converge batch  
