#!/usr/bin/env bash
# Install Grok Build CLI automation bridge onto a Mac Pro / local Mac
# Safe to re-run. Does NOT store secrets — expects XAI_API_KEY / MAKE_WEBHOOK_URL already exported or in Keychain.
set -euo pipefail
REPO_URL="${REPO_URL:-https://github.com/PKEMEDIA/pke-ai-agent-skills.git}"
# Prefer PKE layout; fall back to legacy home clone
if [[ -n "${INSTALL_ROOT:-}" ]]; then
  :
elif [[ -d "$HOME/PKE/pke-ai-agent-skills/.git" ]]; then
  INSTALL_ROOT="$HOME/PKE/pke-ai-agent-skills"
elif [[ -d "$HOME/pke-ai-agent-skills/.git" ]]; then
  INSTALL_ROOT="$HOME/pke-ai-agent-skills"
else
  INSTALL_ROOT="${PKE_ROOT:-$HOME/PKE/pke-ai-agent-skills}"
fi
SKILLS_ROOT="${SKILLS_ROOT:-$HOME/.grok/skills}"
HOOKS_ROOT="${HOOKS_ROOT:-$HOME/.grok/hooks}"

echo "==> Clone / update skills repo ($INSTALL_ROOT)"
mkdir -p "$(dirname "$INSTALL_ROOT")"
if [[ -d "$INSTALL_ROOT/.git" ]]; then
  git -C "$INSTALL_ROOT" pull --ff-only || true
else
  git clone "$REPO_URL" "$INSTALL_ROOT"
fi

echo "==> Inject full PKE Super Mind ecosystem (symlink core + config + rules)"
# Prefer live pack at INSTALL_ROOT (may be ~/PKE/… or legacy ~/pke-ai-agent-skills)
if [[ -x "$INSTALL_ROOT/scripts/inject-ecosystem.sh" ]]; then
  PKE_ROOT="$INSTALL_ROOT" SKILLS_ROOT="$SKILLS_ROOT" HOOKS_ROOT="$HOOKS_ROOT" \
    bash "$INSTALL_ROOT/scripts/inject-ecosystem.sh" || true
else
  mkdir -p "$SKILLS_ROOT" "$HOOKS_ROOT"
  for s in skill-creator skill-orchestrator pke-empire-os voice-commander beast-mode docx spicy-mode grok-build-ios \
           pke-synthetic-intellect autonomous-ecosystem skill-test-suite pke-face-lock pke-official-black-mask \
           covicea-pke-podcast-studio; do
    if [[ -d "$INSTALL_ROOT/$s" ]]; then
      rm -rf "$SKILLS_ROOT/$s"
      ln -sfn "$INSTALL_ROOT/$s" "$SKILLS_ROOT/$s"
      echo "  linked $s"
    fi
  done
  cp -f "$INSTALL_ROOT/hooks/post-tool-use-make.sh" "$HOOKS_ROOT/" 2>/dev/null || true
  chmod +x "$HOOKS_ROOT/post-tool-use-make.sh" 2>/dev/null || true
fi
chmod +x "$INSTALL_ROOT/scripts/"*.sh 2>/dev/null || true

echo "==> Consensus heal gate (same as Skill CI)"
if [[ -x "$INSTALL_ROOT/scripts/consensus-gate.sh" ]] || [[ -f "$INSTALL_ROOT/scripts/consensus-gate.sh" ]]; then
  bash "$INSTALL_ROOT/scripts/consensus-gate.sh" || {
    echo "  WARN: consensus gate failed — continuing deploy so operator can inspect"
  }
elif [[ -f "$INSTALL_ROOT/scripts/consensus-self-heal.mjs" ]]; then
  node "$INSTALL_ROOT/scripts/consensus-self-heal.mjs" --gate || true
  node "$INSTALL_ROOT/scripts/consensus-self-heal.mjs" || true
else
  echo "  skip consensus — engine not in pack yet"
fi

echo "==> Dry-run structural validate (if validate-skill.sh present)"
if [[ -x "$SKILLS_ROOT/skill-creator/scripts/validate-skill.sh" ]] || [[ -x "$INSTALL_ROOT/skill-creator/scripts/validate-skill.sh" ]]; then
  VALIDATE_SCRIPT="${VALIDATE_SCRIPT:-$INSTALL_ROOT/skill-creator/scripts/validate-skill.sh}" \
    bash "$INSTALL_ROOT/scripts/empire-validate.sh" "$SKILLS_ROOT" || true
elif [[ -x /root/.grok/server-skills/skill-creator/scripts/validate-skill.sh ]]; then
  VALIDATE_SCRIPT=/root/.grok/server-skills/skill-creator/scripts/validate-skill.sh \
    bash "$INSTALL_ROOT/scripts/empire-validate.sh" "$SKILLS_ROOT" || true
else
  echo "  skip validate — validate-skill.sh not on this machine yet"
fi

echo "==> Done. Next:"
echo "  export PKE_ROOT=$INSTALL_ROOT"
echo "  export XAI_API_KEY=xai-..."
echo "  export MAKE_WEBHOOK_URL=https://hook.make.com/..."
echo "  bash $INSTALL_ROOT/scripts/session-empire-nightly.sh"
echo "  Wire launchd StartCalendarInterval for nightly summary if desired."
