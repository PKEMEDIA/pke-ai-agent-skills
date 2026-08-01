#!/usr/bin/env bash
# Binaryen optimization pipeline for skill-orchestrator WASM kernels.
# Requires wasm-opt / wasm-as on PATH (e.g. npm package binaryen@131).
#
# Usage:
#   ./binaryen-optimize-wasm.sh input.wat out-dir
#   ./binaryen-optimize-wasm.sh input.wasm out-dir
#
# Produces:
#   out-dir/<name>-raw.wasm
#   out-dir/<name>-O3.wasm
#   out-dir/<name>-Oz-converge.wasm
#   out-dir/<name>-O3.wat  (disassembly of O3)

set -euo pipefail

INPUT="${1:?usage: $0 input.wat|input.wasm out-dir}"
OUTDIR="${2:-./wasm-out}"
mkdir -p "$OUTDIR"

if ! command -v wasm-opt >/dev/null 2>&1; then
  echo "ERROR: wasm-opt not on PATH. Install Binaryen (npm i binaryen@131) or official release." >&2
  exit 1
fi

BASE="$(basename "$INPUT")"
NAME="${BASE%.*}"
EXT="${BASE##*.}"

RAW="$OUTDIR/${NAME}-raw.wasm"
O3="$OUTDIR/${NAME}-O3.wasm"
OZ="$OUTDIR/${NAME}-Oz-converge.wasm"

# Assemble if WAT
if [[ "$EXT" == "wat" || "$EXT" == "wast" ]]; then
  echo "Assembling $INPUT → $RAW"
  # Enable SIMD by default so v128 modules work; scalar modules ignore unused features
  wasm-as "$INPUT" -o "$RAW" --enable-simd
else
  cp "$INPUT" "$RAW"
fi

echo "Optimizing -O3 (speed)"
wasm-opt "$RAW" -O3 --enable-simd --strip-toolchain-annotations -o "$O3"

echo "Optimizing -Oz --converge (size)"
wasm-opt "$RAW" -Oz --converge --enable-simd --strip-toolchain-annotations --strip-debug --strip-dwarf --strip-producers -o "$OZ"

if command -v wasm-dis >/dev/null 2>&1; then
  wasm-dis "$O3" -o "$OUTDIR/${NAME}-O3.wat"
fi

echo ""
echo "Sizes:"
wc -c "$RAW" "$O3" "$OZ" | sed 's|^|  |'
echo ""
echo "Validate:"
node -e "
const fs=require('fs');
for (const f of process.argv.slice(1)) {
  const b=fs.readFileSync(f);
  console.log(' ', f, WebAssembly.validate(b) ? 'OK' : 'INVALID', b.length+'B');
}
" "$RAW" "$O3" "$OZ"

echo ""
echo "Done. Prefer $O3 for speed kernels; $OZ when size dominates."
