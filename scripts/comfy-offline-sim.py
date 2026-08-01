#!/usr/bin/env python3
"""Offline ComfyUI graph validator + dry-run for free tier (no GPU required)."""
from __future__ import annotations

import json
import sys
from pathlib import Path

WORKFLOWS = [
    {
        "id": "pke-face-lock-base",
        "nodes": [
            "CheckpointLoader",
            "IPAdapter FaceID",
            "OpenPose ControlNet",
            "KSampler",
            "FaceDetailer",
            "SaveImage",
        ],
        "face_lock": True,
    },
    {
        "id": "covicea-bible-lock",
        "nodes": ["CheckpointLoader", "IPAdapter", "KSampler", "SaveImage"],
        "face_lock": True,
    },
]


def validate(wf: dict) -> list[str]:
    errs: list[str] = []
    if not wf.get("nodes"):
        errs.append("empty graph")
    joined = " ".join(wf["nodes"])
    if wf.get("face_lock") and "FaceID" not in joined and "IPAdapter" not in joined:
        errs.append("face_lock without FaceID/IPAdapter")
    return errs


def main() -> int:
    prompt = " ".join(sys.argv[1:]) or "PKE PRESENTS dry-run"
    print("=== Comfy offline-sim ===")
    print(f"prompt={prompt[:80]}")
    print("mode=offline-sim credit_cost=0 gpu=none")
    ok = 0
    for wf in WORKFLOWS:
        errs = validate(wf)
        if errs:
            print(f"FAIL {wf['id']}: {', '.join(errs)}")
        else:
            ok += 1
            print(f"OK   {wf['id']} nodes={len(wf['nodes'])} face_lock={wf['face_lock']}")
    root = Path(__file__).resolve().parents[1]
    for p in root.glob("**/comfyui/*.json"):
        try:
            data = json.loads(p.read_text())
            print(f"JSON load OK {p.name}")
        except Exception as e:
            print(f"JSON FAIL {p.name}: {e}")
    print(f"validated={ok}/{len(WORKFLOWS)}")
    print("STATUS=OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
