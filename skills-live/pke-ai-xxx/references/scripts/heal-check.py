#!/usr/bin/env python3
"""AI-XXX pack heal-check — local validate, no GPU / no Imagine burn."""
from __future__ import annotations

import json
import re
import subprocess
import sys
from pathlib import Path

PACK = Path(__file__).resolve().parent.parent
PASS: list[str] = []
FAIL: list[str] = []
WARN: list[str] = []

REQUIRED_FILES = [
    "README.md",
    "ECOSYSTEM.md",
    "CHANGELOG.md",
    "current.json",
    "pipelines/00-overview.md",
    "prompts/double-oral-mmf.md",
    "prompts/male-models.md",
    "prompts/capability-matrix.md",
    "comfyui/workflows.md",
    "comfyui/male-lora-training.md",
    "comfyui/aleah-offline-routing.md",
    "compliance/2257-ai-notes.md",
    "checklists/shoot-day-ai.md",
    "models/notes/_TEMPLATE.md",
    "runs/2026-09.md",
]

LOCK_DOCS = ["README.md", "ECOSYSTEM.md", "compliance/2257-ai-notes.md"]
# Each lock doc must assert LOCKED (or equivalent) for Face Lock and Black Mask
FACE_LOCK_RE = re.compile(r"Face\s*Lock", re.I)
BLACK_MASK_RE = re.compile(r"Black\s*Mask", re.I)
LOCKED_NEAR_RE = re.compile(r"LOCKED|immutable|never\s+train|never\s+unlock", re.I)
# Unlock-path documentation is banned (additive policy)
# Affirmative unlock HOW-TOs only; prohibition lines (never/no/LOCKED) are OK
UNLOCK_DOC_RE = re.compile(
    r"(how\s+to\s+unlock|unlock\s+(?:path|procedure|method|tutorial)|"
    r"steps\s+to\s+unlock|"
    r"(?:train|finetune|fine[\- ]?tune)\s+(?:on|with)\s+(?:Face\s*Lock|Black\s*Mask))",
    re.I,
)
PROHIBITION_RE = re.compile(
    r"\b(never|no|not|don'?t|do\s+not|forbidden|immutable|LOCKED|ban|without)\b",
    re.I,
)
PROMPT_NAMES = ("capability-matrix.md", "double-oral-mmf.md", "male-models.md")


def ok(msg: str) -> None:
    PASS.append(msg)


def bad(msg: str) -> None:
    FAIL.append(msg)


def warn(msg: str) -> None:
    WARN.append(msg)


def check_required_files() -> None:
    for rel in REQUIRED_FILES:
        p = PACK / rel
        if p.is_file():
            ok(f"required present: {rel}")
        else:
            bad(f"required missing: {rel}")


def check_current_json() -> dict | None:
    path = PACK / "current.json"
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception as e:
        bad(f"current.json unreadable: {e}")
        return None
    pin = data.get("prompt_set")
    if not pin or not isinstance(pin, str):
        bad("current.json: missing prompt_set")
        return data
    vdir = PACK / "prompts" / pin
    if not vdir.is_dir():
        bad(f"current.json pins {pin} but prompts/{pin}/ missing")
    else:
        ok(f"current.json pins existing prompts/{pin}/")
        for name in PROMPT_NAMES:
            if not (vdir / name).is_file():
                bad(f"prompts/{pin}/{name} missing")
            else:
                ok(f"pin file present: prompts/{pin}/{name}")
    locks = data.get("locks") or []
    for need in ("face-lock", "black-mask"):
        if need in locks:
            ok(f"current.json locks includes {need}")
        else:
            bad(f"current.json locks missing {need}")
    if data.get("ecosystem_loop") == "active":
        ok("ecosystem_loop: active")
    else:
        warn("ecosystem_loop not set to active (optional field)")
    return data


def check_prompt_mirror(pin: str | None) -> None:
    if not pin:
        return
    vdir = PACK / "prompts" / pin
    if not vdir.is_dir():
        return
    for name in PROMPT_NAMES:
        root = PACK / "prompts" / name
        ver = vdir / name
        if not root.is_file() or not ver.is_file():
            continue
        if root.read_bytes() == ver.read_bytes():
            ok(f"root prompts/{name} mirrors {pin}")
        else:
            bad(
                f"root prompts/{name} differs from prompts/{pin}/{name} "
                f"(sync: cp prompts/{pin}/*.md prompts/)"
            )


def check_locks() -> None:
    for rel in LOCK_DOCS:
        text = (PACK / rel).read_text(encoding="utf-8")
        if not FACE_LOCK_RE.search(text):
            bad(f"{rel}: Face Lock string missing")
        elif not LOCKED_NEAR_RE.search(text):
            bad(f"{rel}: Face Lock present but no LOCKED/immutable language")
        else:
            ok(f"{rel}: Face Lock LOCKED language present")
        if not BLACK_MASK_RE.search(text):
            bad(f"{rel}: Black Mask string missing")
        elif not LOCKED_NEAR_RE.search(text):
            bad(f"{rel}: Black Mask present but no LOCKED/immutable language")
        else:
            ok(f"{rel}: Black Mask LOCKED language present")
        unlock_hits = []
        for line in text.splitlines():
            if UNLOCK_DOC_RE.search(line) and not PROHIBITION_RE.search(line):
                unlock_hits.append(line.strip()[:120])
        if unlock_hits:
            bad(f"{rel}: unlock-path language detected (forbidden): {unlock_hits[0]}")
        else:
            ok(f"{rel}: no unlock-path documentation")


def check_minors_ban() -> None:
    text = (PACK / "README.md").read_text(encoding="utf-8")
    if re.search(r"Minors|never.*teen|No teen", text, re.I):
        ok("README.md: minors ban present")
    else:
        bad("README.md: minors ban language missing")


def check_graphs() -> None:
    validator = PACK / "comfyui" / "graphs" / "validate-graphs.py"
    if not validator.is_file():
        warn("comfyui/graphs/validate-graphs.py missing — skip graph check")
        return
    try:
        r = subprocess.run(
            [sys.executable, str(validator)],
            cwd=str(PACK),
            capture_output=True,
            text=True,
            timeout=60,
        )
    except Exception as e:
        bad(f"validate-graphs.py failed to run: {e}")
        return
    out = (r.stdout or "") + (r.stderr or "")
    if r.returncode == 0:
        ok("validate-graphs.py: PASS")
        for line in out.strip().splitlines()[:3]:
            ok(f"  graph: {line}")
    else:
        bad("validate-graphs.py: FAIL")
        for line in out.strip().splitlines()[:20]:
            bad(f"  {line}")


def main() -> int:
    check_required_files()
    data = check_current_json()
    pin = (data or {}).get("prompt_set") if data else None
    check_prompt_mirror(pin if isinstance(pin, str) else None)
    check_locks()
    check_minors_ban()
    check_graphs()

    print("=== AI-XXX heal-check ===")
    print(f"pack: {PACK}")
    for m in PASS:
        print(f"PASS  {m}")
    for m in WARN:
        print(f"WARN  {m}")
    for m in FAIL:
        print(f"FAIL  {m}")
    print("---")
    print(f"summary: {len(PASS)} pass, {len(WARN)} warn, {len(FAIL)} fail")
    if FAIL:
        print("RESULT: FAIL")
        return 1
    print("RESULT: PASS")
    return 0


if __name__ == "__main__":
    sys.exit(main())
