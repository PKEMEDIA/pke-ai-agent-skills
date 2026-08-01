#!/usr/bin/env bash
# inject-ecosystem.sh — wire PKE Super Mind + permanent skills into local Grok ecosystem
#
# Surfaces:
#   ~/.grok/skills/*     — symlinks to pack (live updates with git pull)
#   ~/.grok/rules/       — permanent Super Mind + brand locks rule
#   ~/.grok/env.sh       — PKE_ROOT + free-tier learn locks
#   ~/.grok/config.toml  — [skills].paths → pack root (full recursive discovery)
#   ~/.grok/hooks/       — optional Make webhook bridge
#   ~/AGENTS.md          — append permanent activation block (idempotent)
#
# Usage:
#   bash scripts/inject-ecosystem.sh
#   PKE_ROOT=~/PKE/pke-ai-agent-skills bash scripts/inject-ecosystem.sh
#   bash scripts/inject-ecosystem.sh --copy   # copy instead of symlink
#   bash scripts/inject-ecosystem.sh --no-config
#
# Safe to re-run. Never stores secrets. Does not call Imagine / SuperGrok.
set -euo pipefail

COPY=0
NO_CONFIG=0
for arg in "$@"; do
  case "$arg" in
    --copy) COPY=1 ;;
    --no-config) NO_CONFIG=1 ;;
    -h|--help)
      sed -n '2,20p' "$0"
      exit 0
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -n "${PKE_ROOT:-}" ] && [ -d "$PKE_ROOT" ]; then
  ROOT="$PKE_ROOT"
elif [ -f "$SCRIPT_DIR/../pke-synthetic-intellect/SKILL.md" ]; then
  ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
elif [ -d "$HOME/PKE/pke-ai-agent-skills" ]; then
  ROOT="$HOME/PKE/pke-ai-agent-skills"
elif [ -d "$HOME/pke-ai-agent-skills" ]; then
  ROOT="$HOME/pke-ai-agent-skills"
else
  echo "ERROR: cannot find pke-ai-agent-skills. Set PKE_ROOT=..." >&2
  exit 1
fi

SKILLS_ROOT="${SKILLS_ROOT:-$HOME/.grok/skills}"
RULES_ROOT="${RULES_ROOT:-$HOME/.grok/rules}"
HOOKS_ROOT="${HOOKS_ROOT:-$HOME/.grok/hooks}"
CONFIG_TOML="${CONFIG_TOML:-$HOME/.grok/config.toml}"
ENV_SH="${ENV_SH:-$HOME/.grok/env.sh}"
AGENTS_MD="${AGENTS_MD:-$HOME/AGENTS.md}"
STAMP=$(date -u +%Y%m%dT%H%M%SZ)

# Permanent + core ecosystem packs (SKILL.md at repo root)
CORE_SKILLS=(
  pke-synthetic-intellect
  skill-orchestrator
  autonomous-ecosystem
  skill-creator
  skill-test-suite
  pke-face-lock
  pke-official-black-mask
  covicea-pke-podcast-studio
  pke-empire-os
  aleah-empire-os
  voice-commander
  beast-mode
  spicy-mode
  grok-build-ios
  docx
  pk-svwo-v1-0
)

ok()   { printf '  OK   %s\n' "$*"; }
warn() { printf '  WARN %s\n' "$*"; }
info() { printf '  ·    %s\n' "$*"; }

echo "=== PKE ECOSYSTEM INJECT $STAMP ==="
echo "ROOT=$ROOT"
echo "SKILLS_ROOT=$SKILLS_ROOT"
echo "mode=$([ "$COPY" -eq 1 ] && echo copy || echo symlink)"

mkdir -p "$SKILLS_ROOT" "$RULES_ROOT" "$HOOKS_ROOT" "$HOME/.grok/config"

# ── 1. Core skills → ~/.grok/skills ──
echo ""
echo "=== 1/6 Core skills → $SKILLS_ROOT ==="
LINKED=0
SKIPPED=0
for s in "${CORE_SKILLS[@]}"; do
  src="$ROOT/$s"
  dst="$SKILLS_ROOT/$s"
  if [ ! -f "$src/SKILL.md" ]; then
    warn "missing pack skill: $s"
    SKIPPED=$((SKIPPED + 1))
    continue
  fi
  # Remove previous link or dir only if it is ours / broken / empty stub
  if [ -L "$dst" ]; then
    rm -f "$dst"
  elif [ -d "$dst" ] && [ ! -f "$dst/SKILL.md" ]; then
    rm -rf "$dst"
  elif [ -d "$dst" ] && [ "$COPY" -eq 1 ]; then
    rm -rf "$dst"
  elif [ -d "$dst" ] && [ ! -L "$dst" ]; then
    # Existing real copy — replace with live symlink unless --copy
    if [ "$COPY" -eq 0 ]; then
      rm -rf "$dst"
    fi
  fi

  if [ "$COPY" -eq 1 ]; then
    rm -rf "$dst"
    cp -R "$src" "$dst"
    ok "copied $s"
  else
    # Relative symlink not required; absolute is clearer for user home
    ln -sfn "$src" "$dst"
    ok "linked $s → $src"
  fi
  LINKED=$((LINKED + 1))
done
info "linked_or_copied=$LINKED skipped=$SKIPPED"

# ── 2. config.toml [skills].paths ──
echo ""
echo "=== 2/6 config.toml skills.paths ==="
if [ "$NO_CONFIG" -eq 1 ]; then
  warn "skipped (--no-config)"
elif [ ! -f "$CONFIG_TOML" ]; then
  cat > "$CONFIG_TOML" <<EOF
[skills]
paths = ["$ROOT"]
EOF
  ok "created $CONFIG_TOML with paths=$ROOT"
else
  if grep -q '\[skills\]' "$CONFIG_TOML" 2>/dev/null; then
    if grep -q "$ROOT" "$CONFIG_TOML" 2>/dev/null; then
      ok "paths already includes pack root"
    else
      # Append path entry under [skills] if paths exists, else add paths=
      if grep -qE '^\s*paths\s*=' "$CONFIG_TOML"; then
        # naive: ensure pack root string present by rewriting paths line if simple
        python3 - "$CONFIG_TOML" "$ROOT" <<'PY'
import re, sys
path, root = sys.argv[1], sys.argv[2]
text = open(path).read()
# If paths = [...] exists, inject root if missing
def inject(m):
    body = m.group(1)
    if root in body:
        return m.group(0)
    body = body.rstrip()
    if body.strip() == "":
        new = f'"{root}"'
    else:
        new = body.rstrip() + f', "{root}"'
    return f"paths = [{new}]"
new, n = re.subn(r'paths\s*=\s*\[([^\]]*)\]', inject, text, count=1)
if n == 0:
    # [skills] present but no paths — insert after [skills]
    new = re.sub(r'(\[skills\]\s*\n)', r'\1paths = ["' + root + '"]\n', text, count=1)
open(path, "w").write(new)
print("updated")
PY
        ok "added pack root to existing paths"
      else
        # insert paths after [skills]
        python3 - "$CONFIG_TOML" "$ROOT" <<'PY'
import re, sys
path, root = sys.argv[1], sys.argv[2]
text = open(path).read()
if not re.search(r'\[skills\]', text):
    text += f'\n[skills]\npaths = ["{root}"]\n'
else:
    text = re.sub(r'(\[skills\]\s*\n)', r'\1paths = ["' + root + '"]\n', text, count=1)
open(path, "w").write(text)
print("ok")
PY
        ok "inserted paths under [skills]"
      fi
    fi
  else
    cat >> "$CONFIG_TOML" <<EOF

# PKE Super Mind pack (injected $STAMP)
[skills]
paths = ["$ROOT"]
EOF
    ok "appended [skills] paths=$ROOT"
  fi
fi

# ── 3. Rules (permanent constitutional) ──
echo ""
echo "=== 3/6 Permanent rules ==="
RULE_FILE="$RULES_ROOT/pke-super-mind.md"
cat > "$RULE_FILE" <<EOF
# PKE Super Mind — permanent ecosystem (Aleah)

Injected: $STAMP  
Source: $ROOT  
Registry: config/permanent-activation.json

## Always online

- **pke-synthetic-intellect** v2 Super Mind L5 (identity: Aleah)
- **skill-orchestrator** · **autonomous-ecosystem** · **skill-creator** · **skill-test-suite**
- **pke-face-lock** · **pke-official-black-mask**
- **covicea-pke-podcast-studio** (spicy default · Magentic hybrid)
- **pke-empire-os** · voice-commander when empire ops apply

## Rules that never bend

1. One company face only (pke-face-lock refs)
2. Pure-black mask only (no chrome / recolor)
3. Title seals only: **PKE PRESENTS** · **A PKE PRODUCTION**
4. Credit-aware routing: local first
5. Progressive disclosure
6. True parallel validation
7. Never claim foundation weights or SuperGrok quotas changed
8. Never store secrets in mind/
9. Learn loop: **zero Imagine / zero video / zero SuperGrok burn**

## Ops

Health / smarter skills → heal → observe → score → improve → remember → optional push  
Podcast → full studio (Orchestrator · HeadWriter · ResearchJournalist · FactChecker · CoHost · Panel · Production · SocialATS · Talent)  
Content → smallest specialist sequence

\`\`\`bash
export PKE_ROOT="$ROOT"
bash "\$PKE_ROOT/scripts/pke-self-heal.sh"
CI_VALIDATE_JOBS=4 bash "\$PKE_ROOT/scripts/ci-validate-skills.sh"
bash "\$PKE_ROOT/scripts/pke-learn.sh"
\`\`\`

Status: **SUPER MIND LIVE · PERMANENT · FREE-TIER FOREVER · imagine_calls=0 on learn**
EOF
ok "wrote $RULE_FILE"

# ── 4. env.sh ──
echo ""
echo "=== 4/6 env.sh ==="
mkdir -p "$(dirname "$ENV_SH")"
touch "$ENV_SH"
# Strip previous PKE inject block if present
if grep -q 'PKE ECOSYSTEM INJECT' "$ENV_SH" 2>/dev/null; then
  python3 - "$ENV_SH" <<'PY'
import sys
from pathlib import Path
p = Path(sys.argv[1])
text = p.read_text()
start = "# >>> PKE ECOSYSTEM INJECT"
end = "# <<< PKE ECOSYSTEM INJECT"
while start in text and end in text:
    a = text.index(start)
    b = text.index(end) + len(end)
    # drop trailing newline after end
    if b < len(text) and text[b] == "\n":
        b += 1
    text = text[:a] + text[b:]
p.write_text(text)
PY
fi
cat >> "$ENV_SH" <<EOF
# >>> PKE ECOSYSTEM INJECT $STAMP
export PKE_ROOT="$ROOT"
export PKE_SUPER_MIND=1
export PKE_FREE_TIER_LEARN=1
export PKE_LEARN_IMAGINE_CALLS=0
# <<< PKE ECOSYSTEM INJECT
EOF
ok "PKE_ROOT + free-tier locks in $ENV_SH"

# ── 5. Hooks + AGENTS.md ──
echo ""
echo "=== 5/6 Hooks + AGENTS.md ==="
if [ -f "$ROOT/hooks/post-tool-use-make.sh" ]; then
  cp -f "$ROOT/hooks/post-tool-use-make.sh" "$HOOKS_ROOT/" 2>/dev/null || true
  chmod +x "$HOOKS_ROOT/post-tool-use-make.sh" 2>/dev/null || true
  ok "hooks/post-tool-use-make.sh"
else
  warn "no post-tool-use-make.sh in pack"
fi

BLOCK_START="<!-- PKE SUPER MIND INJECT -->"
BLOCK_END="<!-- /PKE SUPER MIND INJECT -->"
BLOCK=$(cat <<EOF
$BLOCK_START
# PKE Super Mind (permanent)

Source: \`$ROOT\` · registry: \`config/permanent-activation.json\`

When relevant: load **pke-synthetic-intellect** L5 (Aleah) · skill-orchestrator · autonomous-ecosystem · pke-face-lock · pke-official-black-mask · covicea-pke-podcast-studio. Heal before improve. Local text intelligence first; never burn Imagine/video in learn. One face · pure-black mask · seals **PKE PRESENTS** / **A PKE PRODUCTION** only.
$BLOCK_END
EOF
)

if [ -f "$AGENTS_MD" ]; then
  if grep -q 'PKE SUPER MIND INJECT' "$AGENTS_MD" 2>/dev/null; then
    python3 - "$AGENTS_MD" "$BLOCK_START" "$BLOCK_END" <<'PY'
import sys
from pathlib import Path
p = Path(sys.argv[1])
start, end = sys.argv[2], sys.argv[3]
text = p.read_text()
# remove old block; new block appended by shell after
if start in text and end in text:
    a = text.index(start)
    b = text.index(end) + len(end)
    if b < len(text) and text[b] == "\n":
        b += 1
    text = (text[:a] + text[b:]).rstrip() + "\n"
    p.write_text(text)
PY
  fi
  printf '\n%s\n' "$BLOCK" >> "$AGENTS_MD"
  ok "updated $AGENTS_MD"
else
  printf '%s\n' "$BLOCK" > "$AGENTS_MD"
  ok "created $AGENTS_MD"
fi

# Mirror agents stamp for lowercase agents.md if present
if [ -f "$HOME/Agents.md" ] && [ "$HOME/Agents.md" != "$AGENTS_MD" ]; then
  if ! grep -q 'PKE SUPER MIND INJECT' "$HOME/Agents.md" 2>/dev/null; then
    printf '\n%s\n' "$BLOCK" >> "$HOME/Agents.md"
    ok "updated $HOME/Agents.md"
  fi
fi

# ── 6. Validate injected core ──
echo ""
echo "=== 6/6 Validate core ==="
VALIDATE=""
for cand in \
  "$ROOT/skill-creator/scripts/validate-skill.sh" \
  "$SKILLS_ROOT/skill-creator/scripts/validate-skill.sh"
do
  if [ -f "$cand" ]; then VALIDATE="$cand"; break; fi
done

PASS=0
FAIL=0
if [ -n "$VALIDATE" ]; then
  for s in "${CORE_SKILLS[@]}"; do
    d="$SKILLS_ROOT/$s"
    [ -f "$d/SKILL.md" ] || continue
    out=$(bash "$VALIDATE" "$d" 2>&1) || true
    if echo "$out" | grep -q "^OK:"; then
      PASS=$((PASS + 1))
      ok "validate $s"
    else
      FAIL=$((FAIL + 1))
      warn "validate FAIL $s"
      echo "$out" | head -3 | sed 's/^/     /'
    fi
  done
else
  warn "validate-skill.sh missing — structural presence only"
  for s in "${CORE_SKILLS[@]}"; do
    if [ -f "$SKILLS_ROOT/$s/SKILL.md" ]; then PASS=$((PASS + 1)); else FAIL=$((FAIL + 1)); fi
  done
fi

# Stamp inject state into mind if present
if [ -f "$ROOT/mind/state.json" ]; then
  python3 - "$ROOT/mind/state.json" "$STAMP" "$PASS" "$FAIL" "$SKILLS_ROOT" <<'PY'
import json, sys
from pathlib import Path
p = Path(sys.argv[1])
stamp, pas, fail, skills = sys.argv[2], int(sys.argv[3]), int(sys.argv[4]), sys.argv[5]
state = json.loads(p.read_text())
state["ecosystem_inject"] = {
    "at": stamp,
    "status": "COMPLETE" if fail == 0 else "DEGRADED",
    "skills_root": skills,
    "core_pass": pas,
    "core_fail": fail,
    "method": "symlink-user-grok",
}
obs = state.get("last_observations") or []
obs = [f"ecosystem_inject={stamp}", f"core_validate={pas}/{pas+fail}"] + [o for o in obs if not str(o).startswith("ecosystem_inject")][:10]
state["last_observations"] = obs[:12]
p.write_text(json.dumps(state, indent=2) + "\n")
print("mind stamped")
PY
  ok "mind/state.json ecosystem_inject stamp"
fi

echo ""
echo "=== SUMMARY ==="
echo "core_pass=$PASS core_fail=$FAIL"
echo "skills_root=$SKILLS_ROOT"
echo "pack=$ROOT"
echo "rules=$RULE_FILE"
if [ "$FAIL" -eq 0 ]; then
  echo "STATUS=ECOSYSTEM_INJECTED"
  exit 0
else
  echo "STATUS=ECOSYSTEM_INJECTED_DEGRADED"
  exit 1
fi
