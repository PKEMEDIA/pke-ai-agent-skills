#!/usr/bin/env bash
# Install Grok Build CLI automation bridge onto a Mac Pro / local Mac
# Safe to re-run. Does NOT store secrets — expects XAI_API_KEY / MAKE_WEBHOOK_URL already exported or in Keychain.
set -euo pipefail
REPO_URL="${REPO_URL:-https://github.com/PKEMEDIA/pke-ai-agent-skills.git}"
INSTALL_ROOT="${INSTALL_ROOT:-$HOME/pke-ai-agent-skills}"
SKILLS_ROOT="${SKILLS_ROOT:-$HOME/.grok/skills}"
HOOKS_ROOT="${HOOKS_ROOT:-$HOME/.grok/hooks}"

echo "==> Clone / update skills repo"
if [[ -d "$INSTALL_ROOT/.git" ]]; then
  git -C "$INSTALL_ROOT" pull --ff-only || true
else
  git clone "$REPO_URL" "$INSTALL_ROOT"
fi

echo "==> Mirror lean skills into $SKILLS_ROOT"
mkdir -p "$SKILLS_ROOT" "$HOOKS_ROOT"
for s in skill-creator skill-orchestrator pke-empire-os voice-commander beast-mode docx spicy-mode grok-build-ios; do
  if [[ -d "$INSTALL_ROOT/$s" ]]; then
    rm -rf "$SKILLS_ROOT/$s"
    cp -R "$INSTALL_ROOT/$s" "$SKILLS_ROOT/$s"
    echo "  mirrored $s"
  fi
done

echo "==> Install hooks + scripts"
cp -f "$INSTALL_ROOT/hooks/post-tool-use-make.sh" "$HOOKS_ROOT/" 2>/dev/null || true
chmod +x "$HOOKS_ROOT/post-tool-use-make.sh" 2>/dev/null || true
chmod +x "$INSTALL_ROOT/scripts/"*.sh 2>/dev/null || true

echo "==> Dry-run structural validate (if validate-skill.sh present)"
if [[ -x "$SKILLS_ROOT/skill-creator/scripts/validate-skill.sh" ]]; then
  bash "$INSTALL_ROOT/scripts/empire-validate.sh" "$SKILLS_ROOT" || true
elif [[ -x /root/.grok/server-skills/skill-creator/scripts/validate-skill.sh ]]; then
  VALIDATE_SCRIPT=/root/.grok/server-skills/skill-creator/scripts/validate-skill.sh \
    bash "$INSTALL_ROOT/scripts/empire-validate.sh" "$SKILLS_ROOT" || true
else
  echo "  skip validate — validate-skill.sh not on this machine yet"
fi

echo "==> Done. Next:"
echo "  export XAI_API_KEY=xai-..."
echo "  export MAKE_WEBHOOK_URL=https://hook.make.com/..."
echo "  bash $INSTALL_ROOT/scripts/session-empire-nightly.sh"
echo "  Wire launchd StartCalendarInterval for nightly summary if desired."
