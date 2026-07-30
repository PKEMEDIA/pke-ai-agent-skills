#!/usr/bin/env bash
# PKE self-heal — detect gate failures, auto-repair, re-validate, report.
# Usage: bash /workspace/scripts/pke-self-heal.sh [--push]
set -eu

ROOT="${PKE_ROOT:-/workspace}"
VALIDATE="${VALIDATE_SKILL:-/root/.grok/server-skills/skill-creator/scripts/validate-skill.sh}"
LOG_DIR="$ROOT/artifacts/heal-logs"
STAMP=$(date -u +%Y%m%dT%H%M%SZ)
LOG="$LOG_DIR/heal-$STAMP.log"
PUSH=0
if [ "${1:-}" = "--push" ]; then PUSH=1; fi

mkdir -p "$LOG_DIR"

log() { echo "$@" | tee -a "$LOG"; }
log_action() { ACTIONS+=("$1"); log "ACTION: $1"; }

ACTIONS=()
FAILS_BEFORE=0
FAILS_AFTER=0

log "=== PKE SELF-HEAL $STAMP ==="
log "root=$ROOT push=$PUSH"

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
  if [ ! -f "$VALIDATE" ]; then
    log "WARN: validate-skill.sh missing at $VALIDATE"
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
  if curl -sf -o /dev/null --max-time 2 http://127.0.0.1:8080/; then
    log "app=up"
    return
  fi
  if [ -f "$ROOT/startup.sh" ]; then
    sh "$ROOT/startup.sh" || true
    sleep 2
    if curl -sf -o /dev/null --max-time 3 http://127.0.0.1:8080/; then
      log_action "app-restarted-via-startup.sh"
    else
      log_action "app-restart-FAILED"
      FAILS_AFTER=$((FAILS_AFTER + 1))
    fi
  else
    cat > "$ROOT/startup.sh" <<'EOF'
#!/bin/sh
set -eu
cd /workspace
if curl -sf -o /dev/null --max-time 2 http://127.0.0.1:8080/; then
  exit 0
fi
npm run dev >>/tmp/app-startup.log 2>&1 &
EOF
    chmod +x "$ROOT/startup.sh"
    sh "$ROOT/startup.sh" || true
    sleep 2
    log_action "restored:startup.sh"
  fi
}

heal_junk() {
  if [ -d "$ROOT/artifacts/export-fix" ]; then
    rm -rf "$ROOT/artifacts/export-fix"
    log_action "removed:artifacts/export-fix"
  fi
  local n
  n=$(find "$ROOT/artifacts" -maxdepth 2 \( -name '*.b64' -o -name 'github-push-args.json' -o -name 'args_oneline.json' \) 2>/dev/null | wc -l | tr -d ' ')
  if [ "${n:-0}" -gt 0 ]; then
    find "$ROOT/artifacts" -maxdepth 2 \( -name '*.b64' -o -name 'github-push-args.json' -o -name 'args_oneline.json' \) -delete
    log_action "removed:stray-export-artifacts($n)"
  fi
}

heal_assets() {
  local miss=0 f
  for f in \
    "$ROOT/public/pke/IMG_4440.jpg" \
    "$ROOT/public/pke/IMG_4441.jpg" \
    "$ROOT/public/pke/IMG_4450.jpg" \
    "$ROOT/artifacts/comfyui/pke-face-lock-base.json" \
    "$ROOT/.grok/skills/pke-face-lock/SKILL.md" \
    "$ROOT/.grok/skills/pke-official-black-mask/SKILL.md" \
    "$ROOT/.grok/skills/skill-orchestrator/SKILL.md"
  do
    if [ ! -f "$f" ]; then
      log "MISS $f"
      miss=$((miss + 1))
    fi
  done
  if [ ! -f "$ROOT/artifacts/comfyui/pke-face-lock-base.json" ] && [ -f "$ROOT/artifacts/github-export/comfyui/pke-face-lock-base.json" ]; then
    mkdir -p "$ROOT/artifacts/comfyui"
    cp "$ROOT/artifacts/github-export/comfyui/pke-face-lock-base.json" "$ROOT/artifacts/comfyui/"
    log_action "restored:comfyui-from-staging"
    if [ "$miss" -gt 0 ]; then miss=$((miss - 1)); fi
  fi
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
  if ! command -v gh >/dev/null 2>&1; then
    log_action "github-skip:no-gh"
    return
  fi
  local tmp=/tmp/pke-self-heal-push-$$
  rm -rf "$tmp"
  if ! gh repo clone PKEMEDIA/pke-ai-agent-skills "$tmp" -- --depth 1; then
    log_action "github-clone-FAILED"
    return
  fi
  mkdir -p "$tmp/pke-face-lock" "$tmp/pke-official-black-mask" "$tmp/skill-orchestrator/references" "$tmp/comfyui" "$tmp/skill-orchestrator/scripts"
  cp "$ROOT/.grok/skills/pke-face-lock/SKILL.md" "$tmp/pke-face-lock/SKILL.md"
  cp "$ROOT/.grok/skills/pke-official-black-mask/SKILL.md" "$tmp/pke-official-black-mask/SKILL.md"
  cp "$ROOT/.grok/skills/skill-orchestrator/SKILL.md" "$tmp/skill-orchestrator/SKILL.md"
  cp "$ROOT/.grok/skills/skill-orchestrator/references/pke-brand-map.md" "$tmp/skill-orchestrator/references/pke-brand-map.md"
  if [ -f "$ROOT/scripts/pke-self-heal.sh" ]; then
    cp "$ROOT/scripts/pke-self-heal.sh" "$tmp/skill-orchestrator/scripts/pke-self-heal.sh"
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
  elif [ "$ghst" = "PUSH_FAILED" ] || [ "$ghst" = "FAIL" ]; then
    log_action "github-push-FAILED"
    FAILS_AFTER=$((FAILS_AFTER + 1))
  else
    log_action "github-pushed:$ghst"
  fi
  rm -rf "$tmp"
}

heal_skills
heal_brand_map
heal_app
heal_junk
heal_assets
heal_github

PASS=0
TOTAL=0
for d in "$ROOT"/.grok/skills/*/; do
  [ -d "$d" ] || continue
  TOTAL=$((TOTAL + 1))
  if "$VALIDATE" "$d" >/dev/null 2>&1; then PASS=$((PASS + 1)); fi
done

log "=== SUMMARY ==="
log "skills $PASS/$TOTAL"
log "fails_before_fix=$FAILS_BEFORE fails_remaining=$FAILS_AFTER"
log "actions=${#ACTIONS[@]}"
for a in "${ACTIONS[@]:-}"; do log " - $a"; done
log "log_file=$LOG"

if [ "$FAILS_AFTER" -eq 0 ] && [ "$PASS" -eq "$TOTAL" ]; then
  log "STATUS=HEALTHY"
  exit 0
else
  log "STATUS=DEGRADED"
  exit 1
fi
