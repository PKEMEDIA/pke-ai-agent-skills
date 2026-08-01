#!/usr/bin/env node
/**
 * WASM-accelerated bulk skill validation harness
 * skill-orchestrator speed path — integrity + structural pre-scan.
 *
 * Features:
 *  - WebAssembly memory + checksum (v1 module, verified)
 *  - Automatic JS fallback
 *  - Optional WASI context probe (node:wasi experimental)
 *  - SIMD capability detection (report only; core path stays scalar for portability)
 *
 * Usage:
 *   node wasm-validate-harness.mjs
 *   node wasm-validate-harness.mjs --json /home/workdir/artifacts/validation-report.json
 *   node wasm-validate-harness.mjs --probe-wasi --probe-simd
 */

import fs from "node:fs";
import path from "node:path";
import { performance } from "node:perf_hooks";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));

/** Verified minimal module: memory + version()=1 + checksum(ptr,len)=sum(u8)&255 */
function buildWasmBytes() {
  return Uint8Array.from(
    Buffer.from(
      "AGFzbQEAAAABCwJgAAF/YAJ/fwF/AwMCAAEFAwEAAQcfAwZtZW1vcnkCAAd2ZXJzaW9uAAAIY2hlY2tzdW0AAQo8AgQAQQELNQECf0EAIQJBACEDAkADQCACIAFPDQEgAyAAIAJqLQAAaiEDIAJBAWohAgwACwsgA0H/AXEL",
      "base64",
    ),
  );
}

async function initWasm() {
  try {
    const bytes = buildWasmBytes();
    if (!WebAssembly.validate(bytes)) {
      throw new Error("module failed WebAssembly.validate");
    }
    const mod = await WebAssembly.compile(bytes);
    const instance = await WebAssembly.instantiate(mod);
    return {
      ok: true,
      version: instance.exports.version(),
      memory: instance.exports.memory,
      checksum: instance.exports.checksum,
      mode: "wasm",
    };
  } catch (err) {
    return { ok: false, error: String(err), mode: "js-fallback" };
  }
}

/** Detect SIMD without requiring a full production path */
function probeSimd() {
  // v128 type in type section: 0x7b; i8x16.add opcode fd 1e
  // Validate a minimal SIMD function shape; false = runtime lacks SIMD or binary incomplete
  const candidates = [
    // empty module always true — baseline
    { name: "baseline", bytes: Uint8Array.from([0x00, 0x61, 0x73, 0x6d, 1, 0, 0, 0]) },
  ];
  const results = {};
  for (const c of candidates) {
    results[c.name] = WebAssembly.validate(c.bytes);
  }
  // Feature presence via try/catch on v128-using binary is brittle without wat2wasm.
  // Report Node/V8 version and recommend wat2wasm pipeline for SIMD kernels.
  return {
    baselineValidate: results.baseline,
    note:
      "SIMD kernels require a wat→wasm pipeline (wat2wasm/binaryen). Scalar checksum path is active. V8 13+ supports SIMD when binaries are well-formed.",
    v8: process.versions?.v8 ?? null,
  };
}

async function probeWasi() {
  try {
    const { WASI } = await import("node:wasi");
    const wasi = new WASI({
      version: "preview1",
      args: ["skill-validate"],
      env: {},
      preopens: { "/sandbox": "/tmp" },
    });
    const imports = wasi.getImportObject();
    return {
      available: true,
      experimental: true,
      preview: "preview1",
      importKeys: Object.keys(imports),
      preview1FnCount: imports.wasi_snapshot_preview1
        ? Object.keys(imports.wasi_snapshot_preview1).length
        : 0,
      note:
        "Useful for future sandboxed file I/O inside WASM validators. Current harness uses Node fs (faster, simpler). Adopt WASI when shipping a portable .wasm CLI outside Node.",
    };
  } catch (err) {
    return { available: false, error: String(err) };
  }
}

function validateSkillMd(content, skillName) {
  const issues = [];
  if (!content?.trim()) return { ok: false, issues: ["empty SKILL.md"] };
  if (!content.startsWith("---")) issues.push("missing opening frontmatter fence");
  const fmEnd = content.indexOf("\n---", 3);
  if (fmEnd === -1) issues.push("missing closing frontmatter fence");
  const fm = fmEnd === -1 ? content.slice(0, 500) : content.slice(0, fmEnd);
  const nameMatch = fm.match(/^name:\s*(.+)$/m);
  const descMatch = fm.match(/^description:\s*(.+)$/m);
  if (!nameMatch) issues.push("missing name");
  else {
    const n = nameMatch[1].trim().replace(/^["']|["']$/g, "");
    if (n !== skillName) issues.push(`name mismatch: "${n}" vs dir "${skillName}"`);
    if (!/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(n)) issues.push("name not kebab-case");
  }
  if (!descMatch) issues.push("missing description");
  else if (descMatch[1].trim().length < 20) issues.push("description too short");
  if (!/^#\s+\S+/m.test(content)) issues.push("missing H1 body title");
  if (/(^|\s)(TODO|FIXME):/m.test(content) || /\[TODO\]|\[FIXME\]/.test(content)) {
    issues.push("contains TODO/FIXME placeholder");
  }
  if (/[\x00-\x08\x0b\x0c\x0e-\x1f]/.test(content)) issues.push("control tokens present");
  return { ok: issues.length === 0, issues };
}

function listSkillDirs(root) {
  if (!fs.existsSync(root)) return [];
  return fs
    .readdirSync(root, { withFileTypes: true })
    .filter((d) => d.isDirectory())
    .map((d) => path.join(root, d.name))
    .filter((p) => fs.existsSync(path.join(p, "SKILL.md")));
}

async function main() {
  const args = process.argv.slice(2);
  const roots = [];
  let jsonOut = null;
  let doWasi = false;
  let doSimd = false;
  for (let i = 0; i < args.length; i++) {
    if (args[i] === "--root" && args[i + 1]) roots.push(args[++i]);
    else if (args[i] === "--json" && args[i + 1]) jsonOut = args[++i];
    else if (args[i] === "--probe-wasi") doWasi = true;
    else if (args[i] === "--probe-simd") doSimd = true;
  }
  if (roots.length === 0) {
    roots.push("/home/workdir/.grok/skills", "/root/.grok/skills");
  }

  const t0 = performance.now();
  const wasm = await initWasm();
  const skillDirs = roots.flatMap(listSkillDirs);

  const results = await Promise.all(
    skillDirs.map(async (dir) => {
      const name = path.basename(dir);
      const file = path.join(dir, "SKILL.md");
      const tRead = performance.now();
      const content = fs.readFileSync(file, "utf8");
      const readMs = performance.now() - tRead;
      let wasmChecksum = null;
      if (wasm.ok && wasm.memory && wasm.checksum) {
        try {
          const bytes = Buffer.from(content, "utf8");
          const page = new Uint8Array(wasm.memory.buffer);
          const n = Math.min(bytes.length, page.length);
          page.set(bytes.subarray(0, n), 0);
          wasmChecksum = wasm.checksum(0, n);
        } catch {
          wasmChecksum = null;
        }
      }
      const validation = validateSkillMd(content, name);
      return {
        name,
        path: dir,
        lines: content.split(/\r?\n/).length,
        bytes: Buffer.byteLength(content, "utf8"),
        readMs: Number(readMs.toFixed(3)),
        wasmChecksum,
        ok: validation.ok,
        issues: validation.issues,
      };
    }),
  );

  const t1 = performance.now();
  const pass = results.filter((r) => r.ok).length;
  const fail = results.length - pass;

  const report = {
    timestamp: new Date().toISOString(),
    mode: wasm.mode,
    wasmVersion: wasm.ok ? wasm.version : null,
    wasmError: wasm.ok ? null : wasm.error,
    totalMs: Number((t1 - t0).toFixed(2)),
    skillCount: results.length,
    pass,
    fail,
    results: results.sort((a, b) => a.name.localeCompare(b.name)),
  };

  if (doWasi) report.wasi = await probeWasi();
  if (doSimd) report.simd = probeSimd();

  console.log("=== WASM Skill Validate Harness ===");
  console.log(
    `Mode: ${report.mode}${wasm.ok ? ` (v${wasm.version})` : ` (${wasm.error})`}`,
  );
  console.log(`Skills: ${report.skillCount}  Pass: ${pass}  Fail: ${fail}`);
  console.log(`Total: ${report.totalMs} ms`);
  if (doWasi) {
    console.log(
      `WASI: ${report.wasi.available ? `yes (${report.wasi.preview}, ${report.wasi.preview1FnCount} fns)` : "no"}`,
    );
  }
  if (doSimd) {
    console.log(`SIMD probe: ${JSON.stringify(report.simd)}`);
  }
  if (fail) {
    for (const r of results.filter((x) => !x.ok)) {
      console.log(`FAIL ${r.name}: ${r.issues.join("; ")}`);
    }
  } else {
    console.log("All skills structural-OK under harness rules.");
  }

  if (jsonOut) {
    fs.mkdirSync(path.dirname(jsonOut), { recursive: true });
    fs.writeFileSync(jsonOut, JSON.stringify(report, null, 2));
    console.log(`JSON report: ${jsonOut}`);
  }

  process.exit(fail ? 1 : 0);
}

main().catch((err) => {
  console.error("Harness fatal:", err);
  process.exit(2);
});
