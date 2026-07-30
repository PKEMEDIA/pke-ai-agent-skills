#!/usr/bin/env bash
# PKE Synthetic Intellect — autonomous local learning cycle (free-tier safe).
# Usage:
#   bash /workspace/scripts/pke-learn.sh
#   bash /workspace/scripts/pke-learn.sh --push
# Never calls Imagine / video. Only local files + optional GitHub.
set -eu

ROOT="${PKE_ROOT:-/workspace}"
VALIDATE="${VALIDATE_SKILL:-/root/.grok/server-skills/skill-creator/scripts/validate-skill.sh}"
MIND="$ROOT/artifacts/pke-mind"
HEAL="$ROOT/scripts/pke-self-heal.sh"
LOG_DIR="$MIND/cycles"
STAMP=$(date -u +%Y%m%dT%H%M%SZ)
PUSH=0
[ "${1:-}" = "--push" ] && PUSH=1

mkdir -p "$MIND" "$LOG_DIR" "$MIND/patches"
LOG="$LOG_DIR/cycle-$STAMP.log"

log() { echo "$@" | tee -a "$LOG"; }

log "=== PKE SYNTHETIC INTELLECT CYCLE $STAMP ==="
log "tier=free mode=autonomous-local push=$PUSH"
log "rule=no-imagine no-video no-supergrok-burn"

# ── 0. Self-heal first ──
if [ -f "$HEAL" ]; then
  if bash "$HEAL" >>"$LOG" 2>&1; then
    log "heal=HEALTHY"
  else
    log "heal=DEGRADED (continuing learn on local signals)"
  fi
else
  log "heal=missing-script"
fi

# ── 1. Observe ──
python3 - "$ROOT" "$MIND" "$STAMP" "$LOG" <<'PY'
import json, re, sys, hashlib
from pathlib import Path
from datetime import datetime, timezone

ROOT = Path(sys.argv[1])
MIND = Path(sys.argv[2])
STAMP = sys.argv[3]
LOG = Path(sys.argv[4])

state_path = MIND / "state.json"
lessons_path = MIND / "lessons.md"
if state_path.exists():
    state = json.loads(state_path.read_text())
else:
    state = {"version": "1.0.0", "cycles": 0, "scores": {}, "lessons": [], "improvements_applied": [], "failure_counts": {}}

state.setdefault("free_tier_rules", [
    "never call Imagine or video gen from learn loop",
    "never burn SuperGrok Heavy for self-improvement",
    "local logs + skill text only",
])
state["tier"] = "free"
state["mode"] = "autonomous-local"

observations = []
improvements = []
fail_counts = state.get("failure_counts", {})

def obs(msg):
    observations.append(msg)
    print("OBS:", msg)

def improve(key, detail):
    improvements.append({"key": key, "detail": detail, "at": STAMP})
    print("IMPROVE:", key, "-", detail)

# --- skill validation scan ---
validate = Path("/root/.grok/server-skills/skill-creator/scripts/validate-skill.sh")
skills_dir = ROOT / ".grok" / "skills"
pass_n = fail_n = 0
fail_names = []
for d in sorted(skills_dir.iterdir() if skills_dir.exists() else []):
    if not d.is_dir() or not (d / "SKILL.md").exists():
        continue
    import subprocess
    r = subprocess.run([str(validate), str(d)], capture_output=True, text=True)
    if r.returncode == 0:
        pass_n += 1
    else:
        fail_n += 1
        fail_names.append(d.name)
        err = (r.stderr or r.stdout or "").strip().splitlines()[-1:] or ["unknown"]
        fail_counts[d.name] = fail_counts.get(d.name, 0) + 1
        obs(f"skill_fail:{d.name}:{err[0][:120]}")

obs(f"skills_pass={pass_n} skills_fail={fail_n}")

# --- app gate ---
import urllib.request
app_ok = False
try:
    urllib.request.urlopen("http://127.0.0.1:8080/", timeout=2)
    app_ok = True
    obs("app=up")
except Exception as e:
    obs(f"app=down:{e}")
    fail_counts["app"] = fail_counts.get("app", 0) + 1

# --- asset gates ---
required = [
    ROOT / "public/pke/IMG_4440.jpg",
    ROOT / "public/pke/IMG_4441.jpg",
    ROOT / "public/pke/IMG_4450.jpg",
    ROOT / "artifacts/comfyui/pke-face-lock-base.json",
    ROOT / ".grok/skills/pke-face-lock/SKILL.md",
    ROOT / ".grok/skills/pke-official-black-mask/SKILL.md",
    ROOT / ".grok/skills/skill-orchestrator/SKILL.md",
]
missing = [str(p.relative_to(ROOT)) for p in required if not p.exists()]
if missing:
    obs("missing_assets=" + ",".join(missing))
    fail_counts["assets"] = fail_counts.get("assets", 0) + len(missing)
else:
    obs("assets=complete")

# --- heal log patterns ---
heal_dir = ROOT / "artifacts" / "heal-logs"
recent_fails = []
if heal_dir.exists():
    logs = sorted(heal_dir.glob("heal-*.log"))[-5:]
    for lp in logs:
        t = lp.read_text(errors="ignore")
        for line in t.splitlines():
            if "STILL_FAIL" in line or "FAILED" in line or "MISS " in line:
                recent_fails.append(line.strip())
if recent_fails:
    obs(f"recent_heal_issues={len(recent_fails)}")
    for rf in recent_fails[-5:]:
        obs("heal_signal:" + rf[:140])

# --- read brand skills for improvement opportunities ---
face = (ROOT / ".grok/skills/pke-face-lock/SKILL.md").read_text() if (ROOT / ".grok/skills/pke-face-lock/SKILL.md").exists() else ""
mask = (ROOT / ".grok/skills/pke-official-black-mask/SKILL.md").read_text() if (ROOT / ".grok/skills/pke-official-black-mask/SKILL.md").exists() else ""
orch = (ROOT / ".grok/skills/skill-orchestrator/SKILL.md").read_text() if (ROOT / ".grok/skills/skill-orchestrator/SKILL.md").exists() else ""

# Heuristic improvements (local text intelligence — free tier)
def ensure_section(path: Path, marker: str, section: str, key: str):
    if not path.exists():
        return
    text = path.read_text()
    if marker in text:
        return
    # insert before last stamp or append
    if "## Last orchestration stamp" in text:
        text = text.replace("## Last orchestration stamp", section + "\n## Last orchestration stamp")
    else:
        text = text.rstrip() + "\n\n" + section + "\n"
    path.write_text(text)
    improve(key, f"added section to {path.name}")

# 1) Free-tier efficiency block on face-lock if missing
if face and "Free-tier efficiency" not in face:
    ensure_section(
        ROOT / ".grok/skills/pke-face-lock/SKILL.md",
        "Free-tier efficiency",
        """## Free-tier efficiency (always on)

- Prefer **one** locked prompt block; do not re-describe freckles three ways.
- Attach existing refs from `public/pke/` instead of new Imagine gens when possible.
- On free / low quota: use **ComfyUI local** (`artifacts/comfyui/pke-face-lock-base.json`) for volume.
- Cloud Imagine only for final hero stills — never for exploratory loops.
- Edit loops beat multi-variable first gens (saves SuperGrok Heavy).
""",
        "face-lock-free-tier-block",
    )

# 2) Adaptive negatives from failure_counts
high_fails = sorted(fail_counts.items(), key=lambda x: -x[1])[:5]
if high_fails:
    obs("top_failure_classes=" + ",".join(f"{k}:{v}" for k,v in high_fails))

# Strengthen negatives if plastic/sweat failures historically common
if fail_counts.get("plastic_skin", 0) >= 1 or "plastic" in json.dumps(state.get("lessons", [])).lower():
    pass  # already in negatives

# 3) Orchestrator: autonomous cycle section
if orch and "Synthetic Intellect" not in orch:
    ensure_section(
        ROOT / ".grok/skills/skill-orchestrator/SKILL.md",
        "Synthetic Intellect",
        """## Synthetic Intellect (autonomous · free-tier)

```bash
bash /workspace/scripts/pke-learn.sh          # observe → heal → improve → stamp
bash /workspace/scripts/pke-learn.sh --push   # + sync improvements to GitHub
```

- Runs **locally only** — no Imagine, no video, no SuperGrok burn.
- Learns from heal logs, validate fails, asset gates, and skill text gaps.
- Writes lessons to `artifacts/pke-mind/` and may patch skill docs.
- Always self-heal before applying improvements.
- Safe on free tier forever; cloud gen is optional user action only.
""",
        "orchestrator-synthetic-intellect-block",
    )

# 4) Mask: free-tier note
if mask and "Free-tier" not in mask:
    ensure_section(
        ROOT / ".grok/skills/pke-official-black-mask/SKILL.md",
        "Free-tier",
        """## Free-tier

- Keep the consolidated mask prompt block; do not regenerate variants cloud-side for learning.
- Local Comfy + locked prompt = unlimited practice; cloud only for final title cards.
""",
        "mask-free-tier-block",
    )

# 5) Prompt compression lesson if prompt blocks are long
for name, content in [("face", face), ("mask", mask)]:
    blocks = re.findall(r"```\n(.*?)```", content, re.S)
    for b in blocks:
        words = len(b.split())
        if words > 80:
            obs(f"prompt_verbose:{name}:{words}w")
            # record lesson only; don't auto-truncate brand locks (identity risk)
            lesson = f"Prompt block '{name}' is {words} words — keep for lock fidelity; use short chat triggers on iOS."
            if lesson not in state.get("lessons", []):
                state.setdefault("lessons", []).append(lesson)
                improve("lesson-prompt-length", lesson)

# 6) Score update
scores = state.setdefault("scores", {})
scores["skill_integrity"] = 10 if fail_n == 0 else max(0, 10 - fail_n)
scores["health"] = 10 if app_ok and not missing else (5 if app_ok else 2)
scores["prompt_efficiency"] = min(10, scores.get("prompt_efficiency", 7) + (1 if any(i["key"].endswith("free-tier-block") for i in improvements) else 0))
scores["brand_lock_strength"] = 9 if not missing else 6
scores["autonomy"] = min(10, scores.get("autonomy", 6) + 1)
scores["overall"] = round(sum(scores.get(k, 0) for k in ("skill_integrity", "health", "prompt_efficiency", "brand_lock_strength", "autonomy")) / 5, 2)

state["cycles"] = state.get("cycles", 0) + 1
state["last_cycle"] = STAMP
state["failure_counts"] = fail_counts
state["last_observations"] = observations[-40:]
state.setdefault("improvements_applied", []).extend(improvements)
# keep last 100 improvements
state["improvements_applied"] = state["improvements_applied"][-100:]
state["last_scores"] = scores

# lessons.md append
lessons_path = MIND / "lessons.md"
if not lessons_path.exists():
    lessons_path.write_text("# Lessons\n")
with lessons_path.open("a") as f:
    f.write(f"\n### Cycle {state['cycles']} — {STAMP}\n")
    f.write(f"- scores: {json.dumps(scores)}\n")
    for o in observations[-15:]:
        f.write(f"- obs: {o}\n")
    for i in improvements:
        f.write(f"- improve: {i['key']} — {i['detail']}\n")
    if not improvements:
        f.write("- improve: none (stable)\n")

# cycle report json
report = {
    "stamp": STAMP,
    "scores": scores,
    "observations": observations,
    "improvements": improvements,
    "free_tier": True,
    "imagine_calls": 0,
    "video_calls": 0,
}
(MIND / "cycles" / f"report-{STAMP}.json").write_text(json.dumps(report, indent=2))
state_path.write_text(json.dumps(state, indent=2))

# human summary
print("=== LEARN SUMMARY ===")
print(f"cycle={state['cycles']} overall={scores.get('overall')}")
print(f"improvements={len(improvements)} observations={len(observations)}")
print(f"imagine_calls=0 video_calls=0 (free-tier lock)")
for i in improvements:
    print(f"  + {i['key']}: {i['detail']}")
PY

# Re-validate brand skills after patches
log "=== post-learn validate ==="
PASS=0; FAIL=0
for d in "$ROOT"/.grok/skills/pke-face-lock "$ROOT"/.grok/skills/pke-official-black-mask "$ROOT"/.grok/skills/skill-orchestrator "$ROOT"/.grok/skills/pke-synthetic-intellect; do
  [ -d "$d" ] || continue
  if "$VALIDATE" "$d" >/dev/null 2>&1; then
    PASS=$((PASS+1)); log "OK $(basename $d)"
  else
    FAIL=$((FAIL+1)); log "FAIL $(basename $d)"; "$VALIDATE" "$d" 2>&1 | tee -a "$LOG" || true
  fi
done

# optional github push of mind + skill patches
if [ "$PUSH" -eq 1 ] && command -v gh >/dev/null 2>&1; then
  tmp=/tmp/pke-learn-push-$$
  rm -rf "$tmp"
  gh repo clone PKEMEDIA/pke-ai-agent-skills "$tmp" -- --depth 1
  mkdir -p "$tmp/pke-face-lock" "$tmp/pke-official-black-mask" "$tmp/skill-orchestrator/scripts" "$tmp/skill-orchestrator/references" "$tmp/pke-synthetic-intellect" "$tmp/mind"
  cp "$ROOT/.grok/skills/pke-face-lock/SKILL.md" "$tmp/pke-face-lock/"
  cp "$ROOT/.grok/skills/pke-official-black-mask/SKILL.md" "$tmp/pke-official-black-mask/"
  cp "$ROOT/.grok/skills/skill-orchestrator/SKILL.md" "$tmp/skill-orchestrator/"
  cp "$ROOT/.grok/skills/skill-orchestrator/references/pke-brand-map.md" "$tmp/skill-orchestrator/references/" 2>/dev/null || true
  cp "$ROOT/scripts/pke-self-heal.sh" "$tmp/skill-orchestrator/scripts/" 2>/dev/null || true
  cp "$ROOT/scripts/pke-learn.sh" "$tmp/skill-orchestrator/scripts/" 2>/dev/null || true
  if [ -d "$ROOT/.grok/skills/pke-synthetic-intellect" ]; then
    cp -r "$ROOT/.grok/skills/pke-synthetic-intellect/." "$tmp/pke-synthetic-intellect/" 2>/dev/null || true
  fi
  # mind state without huge logs
  cp "$MIND/state.json" "$tmp/mind/" 2>/dev/null || true
  cp "$MIND/lessons.md" "$tmp/mind/" 2>/dev/null || true
  (
    cd "$tmp"
    git config user.email "pke@media.local"
    git config user.name "PKE Synthetic Intellect"
    git add -A
    if git diff --cached --quiet; then
      log "github=already-synced"
    else
      git commit -m "chore: synthetic intellect cycle $STAMP (free-tier local learn)"
      git push origin main
      log "github=pushed:$(git rev-parse --short HEAD)"
    fi
  )
  rm -rf "$tmp"
fi

log "STATUS=CYCLE_COMPLETE free_tier=1 imagine=0"
log "log=$LOG"
