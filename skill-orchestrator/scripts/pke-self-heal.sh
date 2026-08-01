#!/usr/bin/env bash
# PKE self-heal - detect gate failures, auto-repair, re-validate, report.
# Usage: bash scripts/pke-self-heal.sh [--push] [--force]
# Env:   PKE_ROOT (auto-detected), VALIDATE_SKILL, PKE_HEAL_FORCE=1
#
# Idempotency:
#   - Global run cooldown stamp (artifacts/heal-stamps/run-cooldown.json)
#   - Per-action stamps via heal_stamp_* helpers
#   - Max 2 auto-heal passes per cooldown window unless --force
#   - Consensus engine gate at START (Raft-lite + stamp registry)
set -eu

# Root detection (App Builder /workspace, user home, or cwd)
if [ -n "${PKE_ROOT:-}" ]; then
  ROOT="$PKE_ROOT"
elif [ -d /workspace/.grok/skills ]; then
  ROOT=/workspace
elif [ -d /home/workdir/.grok/skills ]; then
  ROOT=/home/workdir
else
  ROOT="$(pwd)"
fi

# Prefer available validate-skill.sh
if [ -z "${VALIDATE_SKILL:-}" ]; then
  for cand in \
    /root/.grok/skills/skill-creator/scripts/validate-skill.sh \
    /root/.grok/server-skills/skill-creator/scripts/validate-skill.sh \
    /home/workdir/.grok/skills/skill-creator/scripts/validate-skill.sh \
    "$ROOT/.grok/skills/skill-creator/scripts/validate-skill.sh"
  do
    if [ -f "$cand" ]; then VALIDATE_SKILL="$cand"; break; fi
  done
fi
VALIDATE="${VALIDATE_SKILL:-}"

LOG_DIR="$ROOT/artifacts/heal-logs"
STAMP_DIR="$ROOT/artifacts/heal-stamps"
STAMP=$(date -u +%Y%m%dT%H%M%SZ)
LOG="$LOG_DIR/heal-$STAMP.log"
PUSH=0
FORCE=0
for arg in "$@"; do
  case "$arg" in
    --push) PUSH=1 ;;
    --force) FORCE=1 ;;
  esac
done
if [ "${PKE_HEAL_FORCE:-0}" = "1" ]; then FORCE=1; fi

# Global run cooldown: 120s between full self-heal passes (max 2 per window tracked)
RUN_COOLDOWN_SEC=120
MAX_PASSES_PER_WINDOW=2
RUN_STAMP_FILE="$STAMP_DIR/run-cooldown.json"

mkdir -p "$LOG_DIR" "$STAMP_DIR"

log() { echo "$@" | tee -a "$LOG"; }
log_action() { ACTIONS+=("$1"); log "ACTION: $1"; }

ACTIONS=()
FAILS_BEFORE=0
FAILS_AFTER=0
SKIPPED_IDEMPOTENT=0

# ── Idempotency helpers ──
heal_now() { date +%s; }

# action_key target action → 12-char hex
heal_action_key() {
  printf '%s|%s' "$1" "$2" | sha1sum 2>/dev/null | awk '{print substr($1,1,12)}'
}

heal_stamp_path() {
  echo "$STAMP_DIR/stamp-$(heal_action_key "$1" "$2").json"
}

# Returns 0 if action should be SKIPPED (cooldown active + prior ok)
heal_should_skip() {
  local target="$1" action="$2"
  local path now
  if [ "$FORCE" -eq 1 ]; then return 1; fi
  path=$(heal_stamp_path "$target" "$action")
  [ -f "$path" ] || return 1
  now=$(heal_now)
  python3 - "$path" "$now" <<'PY'
import json, sys
path, now = sys.argv[1], int(sys.argv[2])
d = json.load(open(path))
status = d.get("status", "")
cool = int(d.get("cooldownUntil", 0))
if status not in ("ok", "skipped_already_healthy"):
    sys.exit(1)
sys.exit(0 if cool > now else 1)
PY
}

# Write per-action stamp. status=ok|skipped_already_healthy|failed
# cooldown: destructive 120s, soft 60s, failed 30s
heal_stamp_write() {
  local target="$1" action="$2" status="${3:-ok}" result="${4:-}"
  local path now cooldown
  path=$(heal_stamp_path "$target" "$action")
  now=$(heal_now)
  case "$status" in
    failed) cooldown=30 ;;
    *)
      case "$action" in
        *restart*|*archive*|*bulk*|*rewrite*|*push*|*delete*) cooldown=120 ;;
        *) cooldown=60 ;;
      esac
      ;;
  esac
  python3 - "$path" "$target" "$action" "$status" "$result" "$now" "$cooldown" <<'PY'
import json, sys
path, target, action, status, result, now, cooldown = sys.argv[1:8]
now, cooldown = int(now), int(cooldown)
data = {
  "target": target,
  "action": action,
  "status": status,
  "result": result or None,
  "completedAt": now,
  "cooldownUntil": now + cooldown,
  "holderId": "pke-self-heal",
}
with open(path, "w") as f:
  json.dump(data, f, indent=2)
print(f"STAMP {status} {target}/{action} cool={cooldown}s")
PY
}

# Global run-window gate: max 2 passes per RUN_COOLDOWN_SEC unless --force
heal_run_gate() {
  local now passes window_start
  now=$(heal_now)
  if [ "$FORCE" -eq 1 ]; then
    log "run_gate=force-bypass"
    return 0
  fi
  if [ ! -f "$RUN_STAMP_FILE" ]; then
    python3 -c "import json; json.dump({'windowStart':$now,'passes':1}, open('$RUN_STAMP_FILE','w'), indent=2)"
    log "run_gate=first-pass"
    return 0
  fi
  eval "$(python3 - "$RUN_STAMP_FILE" "$now" "$RUN_COOLDOWN_SEC" "$MAX_PASSES_PER_WINDOW" <<'PY'
import json,sys
path, now, cool, maxp = sys.argv[1], int(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4])
d=json.load(open(path))
ws=int(d.get("windowStart",0))
passes=int(d.get("passes",0))
if now - ws > cool:
    d={"windowStart":now,"passes":1}
    json.dump(d, open(path,"w"), indent=2)
    print("decision=allow")
    print("reason=window-reset")
    print(f"passes=1")
elif passes >= maxp:
    print("decision=deny")
    print("reason=max-passes")
    print(f"passes={passes}")
    print(f"remaining={cool-(now-ws)}")
else:
    d["passes"]=passes+1
    json.dump(d, open(path,"w"), indent=2)
    print("decision=allow")
    print("reason=within-window")
    print(f"passes={passes+1}")
PY
)"
  log "run_gate decision=$decision reason=$reason passes=${passes:-?} remaining=${remaining:-0}"
  if [ "$decision" = "deny" ]; then
    return 1
  fi
  return 0
}

log "=== PKE SELF-HEAL $STAMP ==="
log "root=$ROOT push=$PUSH force=$FORCE validate=${VALIDATE:-MISSING}"

# ── Consensus + idempotency gate (START — not dead after exit) ──
# Use --gate (lightweight) so full unit suite is not re-run on every heal pass.
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -f "$SCRIPT_DIR/consensus-self-heal.mjs" ] && command -v node >/dev/null 2>&1; then
  if node "$SCRIPT_DIR/consensus-self-heal.mjs" --gate --json >"$STAMP_DIR/last-consensus.json" 2>"$STAMP_DIR/last-consensus.err"; then
    log "consensus_gate=ok (idempotency ready)"
  else
    log "consensus_gate=warn (engine gate non-zero; continuing with local idempotency)"
  fi
fi

if ! heal_run_gate; then
  log "STATUS=SKIPPED_IDEMPOTENT (max $MAX_PASSES_PER_WINDOW passes / ${RUN_COOLDOWN_SEC}s window; pass --force to override)"
  log "log_file=$LOG"
  exit 0
fi

fix_skill_frontmatter() {
  local sk="$1"
  python3 - "$sk" <<'PY'
import re, sys
from pathlib import Path
path = Path(sys.argv[1])
if not path.exists():
    sys.exit(1)
text = path.read_text()
orig = text

if re.search(r'^description:\s*[>|]', text, re.M):
    lines = text.splitlines(keepends=True)
    out = []
    i = 0
    while i < len(lines):
        line = lines[i]
        if re.match(r'^description:\s*[>|]', line):
            body = []
            i += 1
            while i < len(lines) and (lines[i].startswith('  ') or lines[i].startswith('\t')):
                body.append(lines[i].strip())
                i += 1
            desc = re.sub(r'\s+', ' ', ' '.join(body)).strip()
            desc = desc.replace('<', '(').replace('>', ')').replace(': ', ' - ')
            out.append(f'description: {desc}\n')
            continue
        out.append(line)
        i += 1
    text = ''.join(out)

def clean_desc_line(m):
    d = m.group(1)
    nd = d.replace('<', '(').replace('>', ')').replace(': ', ' - ')
    return 'description: ' + nd

text2 = re.sub(r'^description:\s*(.+)$', clean_desc_line, text, count=1, flags=re.M)
text = text2

if text != orig:
    path.write_text(text)
    print('fixed', path)
    sys.exit(0)
sys.exit(1)
PY
}

heal_skills() {
  local d name
  if [ -z "$VALIDATE" ] || [ ! -f "$VALIDATE" ]; then
    log "WARN: validate-skill.sh missing - skip skill heal"
    return
  fi
  for d in "$ROOT"/.grok/skills/*/; do
    [ -d "$d" ] || continue
    name=$(basename "$d")
    if ! "$VALIDATE" "$d" >/dev/null 2>&1; then
      FAILS_BEFORE=$((FAILS_BEFORE + 1))
      if fix_skill_frontmatter "$d/SKILL.md"; then
        log_action "frontmatter-fix:$name"
      fi
      if ! "$VALIDATE" "$d" >/dev/null 2>&1; then
        log "STILL_FAIL $name"
        FAILS_AFTER=$((FAILS_AFTER + 1))
      else
        log_action "validated-ok:$name"
      fi
    fi
  done
}

heal_brand_map() {
  local map="$ROOT/.grok/skills/skill-orchestrator/references/pke-brand-map.md"
  if [ ! -f "$map" ]; then
    mkdir -p "$(dirname "$map")"
    cat > "$map" <<'EOF'
# PKE Brand Map

## Platforms

Grok iOS · Grok web · Imagine · Build · GitHub connector · Local ComfyUI

## Gen order

1. Load **pke-face-lock** (freckles, copper braids, green-hazel eyes, dry skin)
2. If mask required → **pke-official-black-mask** (pure black dense pyramid spikes, full-grain leather)
3. Title / motion tokens only - **PKE PRESENTS** or **A PKE PRODUCTION**
4. Negatives - plastic skin, chrome spikes, sweat/water when dry, underage

## FaceID vs OpenPose

| Adapter | Role |
|---|---|
| FaceID | WHO — identity from face refs |
| OpenPose | WHERE — limb layout from pose ref |

## Quality rubric (0–10, ship ≥ 8)

| Criterion | Points |
|---|---|
| Freckles + green-hazel + copper braids | 0–3 |
| Dry natural skin | 0–2 |
| Mask pure black dense spikes (no chrome) | 0–2 |
| Title hierarchy single seal line | 0–2 |
| Composition / clear space | 0–1 |

## Assets

| Asset | Path |
|---|---|
| Face ¾ | `public/pke/IMG_4440.jpg` |
| Face front | `public/pke/IMG_4441.jpg` |
| Face window | `public/pke/IMG_4450.jpg` |
| Casting deck | `artifacts/PKE-Face-Lock-Casting-Package.pptx` |
| Comfy workflow | `artifacts/comfyui/pke-face-lock-base.json` |

## GitHub export set

- `pke-face-lock/SKILL.md`
- `pke-official-black-mask/SKILL.md`
- `skill-orchestrator/SKILL.md`
- `skill-orchestrator/references/pke-brand-map.md`
- `comfyui/pke-face-lock-base.json`
- `README.md`

## Recovery

Push lock → tree re-read → missing-only push (max 2) → verify tree.
EOF
    log_action "restored:pke-brand-map.md"
  fi
}

heal_app() {
  # Already healthy → stamp + skip (idempotent)
  if curl -sf -o /dev/null --max-time 2 http://127.0.0.1:8080/; then
    log "app=up"
    heal_stamp_write "app:8080" "restart" "skipped_already_healthy" "already-up" >/dev/null || true
    return
  fi
  if heal_should_skip "app:8080" "restart"; then
    log "app=skip cooldown (idempotent)"
    SKIPPED_IDEMPOTENT=$((SKIPPED_IDEMPOTENT + 1))
    return
  fi
  if [ -f "$ROOT/startup.sh" ]; then
    sh "$ROOT/startup.sh" || true
    sleep 2
    if curl -sf -o /dev/null --max-time 3 http://127.0.0.1:8080/; then
      log_action "app-restarted-via-startup.sh"
      heal_stamp_write "app:8080" "restart" "ok" "restarted" >/dev/null || true
    else
      log_action "app-restart-FAILED"
      heal_stamp_write "app:8080" "restart" "failed" "still-down" >/dev/null || true
      FAILS_AFTER=$((FAILS_AFTER + 1))
    fi
  else
    cat > "$ROOT/startup.sh" <<EOF
#!/bin/sh
set -eu
cd "$ROOT"
if curl -sf -o /dev/null --max-time 2 http://127.0.0.1:8080/; then
  exit 0
fi
npm run dev >>/tmp/app-startup.log 2>&1 &
EOF
    chmod +x "$ROOT/startup.sh"
    sh "$ROOT/startup.sh" || true
    sleep 2
    if curl -sf -o /dev/null --max-time 3 http://127.0.0.1:8080/; then
      log_action "restored:startup.sh+app-up"
      heal_stamp_write "app:8080" "restart" "ok" "startup-restored" >/dev/null || true
    else
      log_action "restored:startup.sh+app-still-down"
      heal_stamp_write "app:8080" "restart" "failed" "startup-still-down" >/dev/null || true
      FAILS_AFTER=$((FAILS_AFTER + 1))
    fi
  fi
}

heal_junk() {
  if [ -d "$ROOT/artifacts/export-fix" ]; then
    rm -rf "$ROOT/artifacts/export-fix"
    log_action "removed:artifacts/export-fix"
  fi
  local n
  n=$(find "$ROOT/artifacts" -maxdepth 2 \( -name '*.b64' -o -name 'github-push-args.json' -o -name 'args_oneline.json' \) 2>/dev/null | wc -l | tr -d ' ')
  n=${n:-0}
  if [ "$n" -gt 0 ] 2>/dev/null; then
    find "$ROOT/artifacts" -maxdepth 2 \( -name '*.b64' -o -name 'github-push-args.json' -o -name 'args_oneline.json' \) -delete
    log_action "removed:stray-export-artifacts($n)"
  fi
}

# Restore dest from first existing source. Never invent binaries.
restore_asset() {
  local dest="$1" name="$2"
  shift 2
  if [ -f "$dest" ]; then
    return 0
  fi
  mkdir -p "$(dirname "$dest")"
  local src
  for src in "$@"; do
    if [ -f "$src" ]; then
      cp "$src" "$dest"
      log_action "restored:$name<-$(basename "$src")"
      return 0
    fi
  done
  log "MISS $dest"
  return 1
}

heal_assets() {
  local miss=0
  mkdir -p "$ROOT/public/pke" "$ROOT/artifacts/comfyui" "$ROOT/artifacts/pke-refs"

  # Face refs: attachments (upload) → pke-refs cache → never invent
  restore_asset "$ROOT/public/pke/IMG_4440.jpg" "IMG_4440" \
    "$ROOT/attachments/IMG_4440.jpg" \
    "$ROOT/artifacts/pke-refs/IMG_4440.jpg" \
    || miss=$((miss + 1))
  restore_asset "$ROOT/public/pke/IMG_4441.jpg" "IMG_4441" \
    "$ROOT/attachments/IMG_4441.jpg" \
    "$ROOT/artifacts/pke-refs/IMG_4441.jpg" \
    || miss=$((miss + 1))
  restore_asset "$ROOT/public/pke/IMG_4450.jpg" "IMG_4450" \
    "$ROOT/attachments/IMG_4450.jpg" \
    "$ROOT/artifacts/pke-refs/IMG_4450.jpg" \
    || miss=$((miss + 1))

  # Seed pke-refs cache from public/ so next cold start can restore without re-upload
  local f
  for f in IMG_4440.jpg IMG_4441.jpg IMG_4450.jpg; do
    if [ -f "$ROOT/public/pke/$f" ] && [ ! -f "$ROOT/artifacts/pke-refs/$f" ]; then
      cp "$ROOT/public/pke/$f" "$ROOT/artifacts/pke-refs/$f"
      log_action "cached:pke-refs/$f"
    fi
  done

  # Comfy workflow: staging export
  restore_asset "$ROOT/artifacts/comfyui/pke-face-lock-base.json" "comfy-json" \
    "$ROOT/artifacts/github-export/comfyui/pke-face-lock-base.json" \
    || miss=$((miss + 1))

  # Brand skill bodies (detect only — text restored by GitHub/export paths elsewhere)
  for f in \
    "$ROOT/.grok/skills/pke-face-lock/SKILL.md" \
    "$ROOT/.grok/skills/pke-official-black-mask/SKILL.md" \
    "$ROOT/.grok/skills/skill-orchestrator/SKILL.md"
  do
    if [ ! -f "$f" ]; then
      log "MISS $f"
      miss=$((miss + 1))
    fi
  done

  if [ "$miss" -gt 0 ]; then
    FAILS_AFTER=$((FAILS_AFTER + miss))
    log_action "asset-misses:$miss"
  fi
}

heal_github() {
  if [ "$PUSH" -ne 1 ]; then
    log "github=skip (pass --push)"
    return
  fi
  if heal_should_skip "github:pke-ai-agent-skills" "push"; then
    log "github=skip cooldown (idempotent)"
    SKIPPED_IDEMPOTENT=$((SKIPPED_IDEMPOTENT + 1))
    return
  fi
  if ! command -v gh >/dev/null 2>&1; then
    log_action "github-skip:no-gh"
    FAILS_AFTER=$((FAILS_AFTER + 1))
    return
  fi
  local tmp=/tmp/pke-self-heal-push-$$
  rm -rf "$tmp"
  if ! gh repo clone PKEMEDIA/pke-ai-agent-skills "$tmp" -- --depth 1; then
    log_action "github-clone-FAILED"
    FAILS_AFTER=$((FAILS_AFTER + 1))
    return
  fi
  mkdir -p "$tmp/pke-face-lock" "$tmp/pke-official-black-mask" "$tmp/skill-orchestrator/references" "$tmp/comfyui" "$tmp/skill-orchestrator/scripts" "$tmp/scripts"

  # Guarded copies — missing sources must not abort under set -e
  local copied=0
  for pair in \
    "$ROOT/.grok/skills/pke-face-lock/SKILL.md|$tmp/pke-face-lock/SKILL.md" \
    "$ROOT/.grok/skills/pke-official-black-mask/SKILL.md|$tmp/pke-official-black-mask/SKILL.md" \
    "$ROOT/.grok/skills/skill-orchestrator/SKILL.md|$tmp/skill-orchestrator/SKILL.md" \
    "$ROOT/.grok/skills/skill-orchestrator/references/pke-brand-map.md|$tmp/skill-orchestrator/references/pke-brand-map.md"
  do
    src="${pair%%|*}"
    dst="${pair#*|}"
    if [ -f "$src" ]; then
      cp "$src" "$dst"
      copied=$((copied + 1))
    else
      log "WARN: skip missing source $src"
    fi
  done

  if [ -f "$ROOT/scripts/pke-self-heal.sh" ]; then
    cp "$ROOT/scripts/pke-self-heal.sh" "$tmp/skill-orchestrator/scripts/pke-self-heal.sh"
    cp "$ROOT/scripts/pke-self-heal.sh" "$tmp/scripts/pke-self-heal.sh"
    copied=$((copied + 1))
  fi
  if [ -f "$ROOT/scripts/pke-learn.sh" ]; then
    cp "$ROOT/scripts/pke-learn.sh" "$tmp/skill-orchestrator/scripts/pke-learn.sh"
    cp "$ROOT/scripts/pke-learn.sh" "$tmp/scripts/pke-learn.sh"
    copied=$((copied + 1))
  fi
  if [ -f "$ROOT/artifacts/comfyui/pke-face-lock-base.json" ]; then
    cp "$ROOT/artifacts/comfyui/pke-face-lock-base.json" "$tmp/comfyui/"
  fi
  if [ -f "$ROOT/artifacts/comfyui/README-pke-face-lock-base.md" ]; then
    cp "$ROOT/artifacts/comfyui/README-pke-face-lock-base.md" "$tmp/comfyui/"
  fi
  if [ -f "$ROOT/artifacts/github-export/README.md" ]; then
    cp "$ROOT/artifacts/github-export/README.md" "$tmp/README.md"
  fi

  if [ "$copied" -eq 0 ]; then
    log_action "github-skip:nothing-to-copy"
    rm -rf "$tmp"
    return
  fi

  (
    cd "$tmp"
    git config user.email "pke@media.local"
    git config user.name "PKE Self-Heal"
    git add -A
    if git diff --cached --quiet; then
      echo "SYNCED" > /tmp/pke-heal-gh-status
    else
      git commit -m "chore: self-heal sync $(date -u +%Y-%m-%dT%H:%MZ)"
      if git push origin main; then
        git rev-parse --short HEAD > /tmp/pke-heal-gh-status
      else
        echo "PUSH_FAILED" > /tmp/pke-heal-gh-status
      fi
    fi
  )
  ghst=$(cat /tmp/pke-heal-gh-status 2>/dev/null || echo FAIL)
  if [ "$ghst" = "SYNCED" ]; then
    log "github=already-synced"
    heal_stamp_write "github:pke-ai-agent-skills" "push" "skipped_already_healthy" "synced" >/dev/null || true
  elif [ "$ghst" = "PUSH_FAILED" ] || [ "$ghst" = "FAIL" ]; then
    log_action "github-push-FAILED"
    heal_stamp_write "github:pke-ai-agent-skills" "push" "failed" "$ghst" >/dev/null || true
    FAILS_AFTER=$((FAILS_AFTER + 1))
  else
    log_action "github-pushed:$ghst"
    heal_stamp_write "github:pke-ai-agent-skills" "push" "ok" "$ghst" >/dev/null || true
  fi
  rm -rf "$tmp"
}

# run
heal_skills
heal_brand_map
heal_app
heal_junk
heal_assets
heal_github

PASS=0
TOTAL=0
if [ -n "$VALIDATE" ] && [ -f "$VALIDATE" ]; then
  for d in "$ROOT"/.grok/skills/*/; do
    [ -d "$d" ] || continue
    [ -f "$d/SKILL.md" ] || continue
    TOTAL=$((TOTAL + 1))
    if "$VALIDATE" "$d" >/dev/null 2>&1; then PASS=$((PASS + 1)); fi
  done
else
  log "WARN: final validate skipped (no validate-skill.sh)"
fi

log "=== SUMMARY ==="
log "skills $PASS/$TOTAL"
log "fails_before_fix=$FAILS_BEFORE fails_remaining=$FAILS_AFTER"
log "skipped_idempotent=$SKIPPED_IDEMPOTENT"
log "actions=${#ACTIONS[@]}"
if [ ${#ACTIONS[@]} -gt 0 ]; then
  for a in "${ACTIONS[@]}"; do log " - $a"; done
else
  log " - (none)"
fi
log "log_file=$LOG"
log "stamp_dir=$STAMP_DIR"

if [ "$FAILS_AFTER" -eq 0 ]; then
  if [ "$TOTAL" -eq 0 ] || [ "$PASS" -eq "$TOTAL" ]; then
    log "STATUS=HEALTHY"
    exit 0
  fi
fi
log "STATUS=DEGRADED"
exit 1
