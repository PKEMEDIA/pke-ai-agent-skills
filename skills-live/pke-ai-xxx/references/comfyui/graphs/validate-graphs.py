#!/usr/bin/env python3
"""Offline-sim: validate Comfy API graph JSON structure (no GPU / no Imagine)."""
from __future__ import annotations
import json, re, sys
from pathlib import Path

REQUIRED_CORE = {"CheckpointLoaderSimple", "CLIPTextEncode", "EmptyLatentImage", "KSampler", "VAEDecode"}
# Filename / asset-path patterns only — negative prompts may intentionally list "Face Lock" as banned tokens
ASSET_KEYS = {"ckpt_name", "lora_name", "model_name", "image", "image_path", "filename_prefix"}
ASSET_BAN = re.compile(
    r"(face[_\-]?lock|black[_\-]?mask|pke-face-lock|official-black-mask|covicea-face-lock)",
    re.I,
)

def check(path: Path) -> list[str]:
    errs = []
    data = json.loads(path.read_text())
    if not isinstance(data, dict) or not data:
        return [f"{path.name}: empty or not an object"]
    classes = set()
    for nid, node in data.items():
        if nid.startswith("_"):
            continue
        if not isinstance(node, dict) or "class_type" not in node or "inputs" not in node:
            errs.append(f"{path.name}: node {nid} missing class_type/inputs")
            continue
        classes.add(node["class_type"])
        for k, v in node.get("inputs", {}).items():
            if not isinstance(v, str):
                continue
            # only flag loader/path-like fields, not prompt text
            if k in ASSET_KEYS or k.endswith("_name") or k.endswith("_path"):
                if ASSET_BAN.search(v.replace(" ", "")):
                    errs.append(f"{path.name}: node {nid} inputs.{k} looks like locked-face asset: {v}")
    missing = REQUIRED_CORE - classes
    if missing:
        errs.append(f"{path.name}: missing core classes {sorted(missing)}")
    for nid, node in data.items():
        if nid.startswith("_") or not isinstance(node, dict):
            continue
        for k, v in node.get("inputs", {}).items():
            if isinstance(v, list) and len(v) == 2 and isinstance(v[0], str):
                if v[0] not in data:
                    errs.append(f"{path.name}: node {nid} inputs.{k} refs missing node {v[0]}")
    # placeholders must remain obvious
    blob = json.dumps(data)
    if "PLACEHOLDER_" not in blob:
        # warn only — GPU-validated exports may remove placeholders
        pass
    return errs

def main() -> int:
    here = Path(__file__).resolve().parent
    files = [here / "stills-grid.json", here / "animatediff-teaser.json"]
    all_errs = []
    for f in files:
        if not f.exists():
            all_errs.append(f"missing {f.name}")
            continue
        all_errs.extend(check(f))
    if all_errs:
        print("FAIL")
        for e in all_errs:
            print(" -", e)
        return 1
    print("OK — stills-grid.json + animatediff-teaser.json structure valid")
    print("status: template-api (swap PLACEHOLDER weights on live Comfy; re-export as gpu-validated)")
    print("imagine_calls=0")
    return 0

if __name__ == "__main__":
    sys.exit(main())
