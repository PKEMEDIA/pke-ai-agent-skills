#!/usr/bin/env bash
# wasm-opt-pinned.sh — apply pinned Binaryen levels (v1.1 optimized flags)
#
# Usage:
#   ./wasm-opt-pinned.sh <input.wasm> [output.wasm] [--profile NAME]
#   ./wasm-opt-pinned.sh --print-pins
#   ./wasm-opt-pinned.sh --cargo-snippet
#
# Profiles: dev | speed | size | size_balanced | release | release_converge | release_size | ios
#
# Env:
#   WASM_OPT_PROFILE  default: release
#   WASM_OPT_BIN      path to wasm-opt (default: wasm-opt on PATH)
#   WASM_OPT_SIMD=1   append --enable-simd (v128 modules)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ORCH_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG="${ORCH_ROOT}/config/wasm-opt-levels.toml"
WASM_OPT_BIN="${WASM_OPT_BIN:-wasm-opt}"

# v1.1 pins — keep in sync with config/wasm-opt-levels.toml
profile_args() {
  case "$1" in
    dev)
      echo ""
      ;;
    speed|release)
      echo "-O3 --strip-toolchain-annotations"
      ;;
    size)
      echo "-Oz --strip-toolchain-annotations --strip-debug --strip-dwarf --strip-producers"
      ;;
    size_balanced)
      echo "-Os --strip-toolchain-annotations"
      ;;
    release_converge)
      echo "-O3 --converge --strip-toolchain-annotations"
      ;;
    release_size|ios)
      echo "-Oz --converge --strip-toolchain-annotations --strip-debug --strip-dwarf --strip-producers"
      ;;
    *)
      echo "Unknown profile: $1" >&2
      echo "Valid: dev speed size size_balanced release release_converge release_size ios" >&2
      return 1
      ;;
  esac
}

print_pins() {
  cat <<'EOF'
Pinned wasm-opt levels (skill-orchestrator v1.1.0 · optimized 2026-07-28)

| Profile            | Args                                                                 | Use |
|--------------------|----------------------------------------------------------------------|-----|
| dev                | (skip)                                                               | Fast iteration |
| speed              | -O3 --strip-toolchain-annotations                                    | Hot paths / games |
| size               | -Oz --strip-toolchain-annotations --strip-debug --strip-dwarf --strip-producers | Payload-bound |
| size_balanced      | -Os --strip-toolchain-annotations                                    | Balanced size |
| release            | -O3 --strip-toolchain-annotations                                    | **Default ship** |
| release_converge   | -O3 --converge --strip-toolchain-annotations                         | Fixed-point speed |
| release_size / ios | -Oz --converge --strip-toolchain-annotations --strip-debug --strip-dwarf --strip-producers | iOS / max size |

Env: WASM_OPT_SIMD=1 → append --enable-simd
Gate: validate → opt → validate
Config: config/wasm-opt-levels.toml
EOF
}

cargo_snippet() {
  cat <<'EOF'
# Paste into Cargo.toml — pinned skill-orchestrator release v1.1
[package.metadata.wasm-pack.profile.dev]
wasm-opt = false

[package.metadata.wasm-pack.profile.release]
wasm-opt = ["-O3", "--strip-toolchain-annotations"]

# iOS / size-bound alternate:
# [package.metadata.wasm-pack.profile.release]
# wasm-opt = ["-Oz", "--converge", "--strip-toolchain-annotations", "--strip-debug", "--strip-dwarf", "--strip-producers"]
EOF
}

validate_wasm() {
  local f="$1"
  if command -v wasm-validate >/dev/null 2>&1; then
    wasm-validate "$f"
    return $?
  fi
  if command -v node >/dev/null 2>&1; then
    node -e '
      const fs=require("fs");
      const b=fs.readFileSync(process.argv[1]);
      if(!WebAssembly.validate(b)){console.error("INVALID",process.argv[1]);process.exit(1)}
      console.error("OK (node WebAssembly.validate)", process.argv[1]);
    ' "$f"
    return $?
  fi
  echo "WARN: no wasm-validate or node; skipping validate for $f" >&2
  return 0
}

if [ "${1:-}" = "--print-pins" ] || [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  print_pins
  exit 0
fi
if [ "${1:-}" = "--cargo-snippet" ]; then
  cargo_snippet
  exit 0
fi

if [ $# -lt 1 ]; then
  echo "Usage: $0 <input.wasm> [output.wasm] [--profile NAME]" >&2
  exit 1
fi

IN=""
OUT=""
PROFILE="${WASM_OPT_PROFILE:-release}"

while [ $# -gt 0 ]; do
  case "$1" in
    --profile)
      PROFILE="$2"
      shift 2
      ;;
    --profile=*)
      PROFILE="${1#--profile=}"
      shift
      ;;
    *)
      if [ -z "$IN" ]; then
        IN="$1"
      elif [ -z "$OUT" ]; then
        OUT="$1"
      else
        echo "Unexpected arg: $1" >&2
        exit 1
      fi
      shift
      ;;
  esac
done

OUT="${OUT:-${IN%.wasm}.opt.wasm}"

if [ ! -f "$IN" ]; then
  echo "FAIL: input not found: $IN" >&2
  exit 1
fi

if [ "$PROFILE" = "dev" ]; then
  echo "SKIP wasm-opt (profile=dev); copying $IN → $OUT"
  cp -f "$IN" "$OUT"
  exit 0
fi

ARGS="$(profile_args "$PROFILE")" || exit 1

# Optional SIMD feature enable for v128 modules
if [ "${WASM_OPT_SIMD:-0}" = "1" ]; then
  ARGS="$ARGS --enable-simd"
fi

if ! command -v "$WASM_OPT_BIN" >/dev/null 2>&1; then
  echo "FAIL: wasm-opt not on PATH (WASM_OPT_BIN=$WASM_OPT_BIN)" >&2
  echo "Install Binaryen or set WASM_OPT_BIN. Pins: $0 --print-pins" >&2
  exit 1
fi

echo "=== pre-validate ==="
validate_wasm "$IN"

echo "=== wasm-opt profile=$PROFILE args: $ARGS ==="
# shellcheck disable=SC2086
"$WASM_OPT_BIN" $ARGS "$IN" -o "$OUT"

echo "=== post-validate ==="
validate_wasm "$OUT"

echo "OK: $IN → $OUT (profile=$PROFILE v1.1)"
wc -c "$IN" "$OUT" 2>/dev/null || true
