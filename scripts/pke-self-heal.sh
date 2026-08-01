#!/usr/bin/env bash
# PKE self-heal - detect gate failures, auto-repair, re-validate, report.
# Usage: bash scripts/pke-self-heal.sh [--push]
# Env:   PKE_ROOT (auto-detected), VALIDATE_SKILL
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

# Prefer available validate-skill.sh (repo-native first, then deploy layouts)
if [ -z "${VALIDATE_SKILL:-}" ]; then
  for cand in \
    "$ROOT/skill-creator/scripts/validate-skill.sh" \
    "$ROOT/.grok/skills/skill-creator/scripts/validate-skill.sh" \
    /root/.grok/skills/skill-creator/scripts/validate-skill.sh \
    /root/.grok/server-skills/skill-creator/scripts/validate-skill.sh \
    /home/workdir/.grok/skills/skill-creator/scripts/validate-skill.sh
  do
    if [ -f "$cand" ]; then VALIDATE_SKILL="$cand"; break; fi
  done
fi
VALIDATE="${VALIDATE_SKILL:-}"

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
log "root=$ROOT push=$PUSH validate=${VALIDATE:-MISSING}"

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
  if curl -sf -o /dev/null --max-time 2 http://127.0.0.1:8080/; then
    log "app=up"
    return
  fi
  # Skills monorepo may have no Node app — skip hard-fail without package.json
  if [ ! -f "$ROOT/package.json" ]; then
    log "app=skip (no package.json — skills-only root)"
    # Rewrite broken /workspace hardcode if present
    if [ -f "$ROOT/startup.sh" ] && grep -q '/workspace/pke-ai-agent-skills' "$ROOT/startup.sh" 2>/dev/null; then
      cat > "$ROOT/startup.sh" <<EOF
#!/bin/sh
set -eu
cd "$ROOT"
if curl -sf -o /dev/null --max-time 2 http://127.0.0.1:8080/; then
  exit 0
fi
if [ -f package.json ]; then
  npm run dev >>/tmp/app-startup.log 2>&1 &
fi
EOF
      chmod +x "$ROOT/startup.sh"
      log_action "restored:startup.sh-local-ROOT"
    fi
    return
  fi
  if [ -f "$ROOT/startup.sh" ]; then
    # Heal /workspace hardcode for Mac / non-container hosts
    if grep -q '/workspace/pke-ai-agent-skills' "$ROOT/startup.sh" 2>/dev/null; then
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
      log_action "restored:startup.sh-local-ROOT"
    fi
    sh "$ROOT/startup.sh" || true
    sleep 2
    if curl -sf -o /dev/null --max-time 3 http://127.0.0.1:8080/; then
      log_action "app-restarted-via-startup.sh"
    else
      log_action "app-restart-FAILED"
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
    else
      log_action "restored:startup.sh+app-still-down"
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

heal_assets() {
  local miss=0 f

  # Wire repo-root skills into .grok/skills (symlink) for Grok layout consumers.
  # Replace incomplete stubs (e.g. brand-map-only skill-orchestrator) with real packs.
  mkdir -p "$ROOT/.grok/skills"
  for skill in pke-face-lock pke-official-black-mask skill-orchestrator skill-creator \
               pke-synthetic-intellect autonomous-ecosystem skill-test-suite \
               covicea-pke-podcast-studio; do
    if [ ! -f "$ROOT/$skill/SKILL.md" ]; then
      continue
    fi
    target="$ROOT/.grok/skills/$skill"
    if [ -L "$target" ]; then
      continue
    fi
    if [ -d "$target" ] && [ ! -f "$target/SKILL.md" ]; then
      # Preserve any orphan files (e.g. brand map) into canonical pack first
      if [ -f "$target/references/pke-brand-map.md" ] && [ ! -f "$ROOT/$skill/references/pke-brand-map.md" ]; then
        mkdir -p "$ROOT/$skill/references"
        cp "$target/references/pke-brand-map.md" "$ROOT/$skill/references/"
        log_action "merged:brand-map-into-$skill"
      fi
      rm -rf "$target"
      ln -sfn "../../$skill" "$target"
      log_action "replaced-stub:.grok/skills/$skill"
    elif [ ! -e "$target" ]; then
      ln -sfn "../../$skill" "$target"
      log_action "linked:.grok/skills/$skill"
    fi
  done

  # Comfy face-lock workflow: repo comfyui/ → artifacts/comfyui/
  if [ ! -f "$ROOT/artifacts/comfyui/pke-face-lock-base.json" ]; then
    if [ -f "$ROOT/comfyui/pke-face-lock-base.json" ]; then
      mkdir -p "$ROOT/artifacts/comfyui"
      cp "$ROOT/comfyui/pke-face-lock-base.json" "$ROOT/artifacts/comfyui/"
      [ -f "$ROOT/comfyui/README-pke-face-lock-base.md" ] && \
        cp "$ROOT/comfyui/README-pke-face-lock-base.md" "$ROOT/artifacts/comfyui/" || true
      log_action "restored:comfyui-from-repo"
    elif [ -f "$ROOT/artifacts/github-export/comfyui/pke-face-lock-base.json" ]; then
      mkdir -p "$ROOT/artifacts/comfyui"
      cp "$ROOT/artifacts/github-export/comfyui/pke-face-lock-base.json" "$ROOT/artifacts/comfyui/"
      log_action "restored:comfyui-from-staging"
    fi
  fi

  # Binary face refs are optional for free-tier text learn (often not in git). Soft warn only.
  local soft=0
  for f in \
    "$ROOT/public/pke/IMG_4440.jpg" \
    "$ROOT/public/pke/IMG_4441.jpg" \
    "$ROOT/public/pke/IMG_4450.jpg"
  do
    if [ ! -f "$f" ] && [ ! -L "$f" ]; then
      log "WARN soft-miss face ref (optional free-tier): $f"
      soft=$((soft + 1))
    fi
  done
  if [ "$soft" -gt 0 ]; then
    log_action "soft-miss-face-refs:$soft"
  fi

  for f in \
    "$ROOT/artifacts/comfyui/pke-face-lock-base.json" \
    "$ROOT/.grok/skills/pke-face-lock/SKILL.md" \
    "$ROOT/.grok/skills/pke-official-black-mask/SKILL.md" \
    "$ROOT/.grok/skills/skill-orchestrator/SKILL.md"
  do
    if [ ! -f "$f" ] && [ ! -L "$f" ]; then
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
  elif [ "$ghst" = "PUSH_FAILED" ] || [ "$ghst" = "FAIL" ]; then
    log_action "github-push-FAILED"
    FAILS_AFTER=$((FAILS_AFTER + 1))
  else
    log_action "github-pushed:$ghst"
  fi
  rm -rf "$tmp"
}

# run — wire assets/links first so skill heal sees real packs
heal_app
heal_junk
heal_assets
heal_brand_map
heal_skills
heal_github

PASS=0
TOTAL=0
if [ -n "$VALIDATE" ] && [ -f "$VALIDATE" ]; then
  # Prefer .grok/skills; fall back to repo-root skill packs with SKILL.md
  local_skill_dirs=""
  for d in "$ROOT"/.grok/skills/*/; do
    [ -d "$d" ] || continue
    [ -f "$d/SKILL.md" ] || continue
    local_skill_dirs="$local_skill_dirs $d"
  done
  if [ -z "$(echo $local_skill_dirs)" ]; then
    for d in "$ROOT"/*/; do
      [ -f "$d/SKILL.md" ] || continue
      local_skill_dirs="$local_skill_dirs $d"
    done
  fi
  for d in $local_skill_dirs; do
    TOTAL=$((TOTAL + 1))
    if bash "$VALIDATE" "$d" >/dev/null 2>&1; then PASS=$((PASS + 1)); fi
  done
else
  log "WARN: final validate skipped (no validate-skill.sh)"
fi

log "=== SUMMARY ==="
log "skills $PASS/$TOTAL"
log "fails_before_fix=$FAILS_BEFORE fails_remaining=$FAILS_AFTER"
log "actions=${#ACTIONS[@]}"
if [ ${#ACTIONS[@]} -gt 0 ]; then
  for a in "${ACTIONS[@]}"; do log " - $a"; done
else
  log " - (none)"
fi
log "log_file=$LOG"

if [ "$FAILS_AFTER" -eq 0 ]; then
  if [ "$TOTAL" -eq 0 ] || [ "$PASS" -eq "$TOTAL" ]; then
    log "STATUS=HEALTHY"
    exit 0
  fi
fi
log "STATUS=DEGRADED"
exit 1
