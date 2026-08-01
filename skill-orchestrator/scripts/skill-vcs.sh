#!/bin/bash
# Skill Version Control Helper + Bisect Automation
# Beast Mode Skill Orchestrator - 2026-07-25
# Polished 2026-08-01: graceful non-git (file snapshot fallback + no fatal noise)

SKILLS_ROOT="/home/workdir/.grok/skills"
cd "$SKILLS_ROOT" || exit 1

is_git_repo() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1
}

generate_smart_message() {
  local reason="${1:-auto}"
  local changed
  changed=$(git status --porcelain 2>/dev/null | awk '{print $2}' | sed 's|/.*||' | sort -u | head -15 | tr '\n' ',' | sed 's/,$//')
  if [ -z "$changed" ]; then
    echo "Auto-snapshot: no skill changes detected ($reason) $(date '+%Y-%m-%d %H:%M')"
  else
    echo "Auto-snapshot [$reason]: $changed $(date '+%Y-%m-%d %H:%M')"
  fi
}

# File-based snapshot when not a git repo (timestamped tar of changed SKILL.md + scripts)
file_snapshot() {
  local reason="${1:-orchestrator}"
  local stamp
  stamp=$(date '+%Y%m%d-%H%M%S')
  local dest="/home/workdir/artifacts/skill-vcs-snapshots"
  mkdir -p "$dest"
  local archive="$dest/skills-snapshot-${stamp}-${reason}.tar.gz"
  # Best-effort: pack only skill roots that have SKILL.md
  tar -czf "$archive" \
    --exclude='*.mp4' --exclude='*.bak*' --exclude='node_modules' \
    -C /home/workdir/.grok skills \
    -C /root/.grok skills 2>/dev/null || true
  if [ -f "$archive" ]; then
    echo "File-snapshot created (non-git): $archive"
  else
    echo "File-snapshot skipped / failed (non-git mode)"
  fi
}

case "${1:-status}" in
  status)
    echo "=== Skill Ecosystem Git Status ==="
    if is_git_repo; then
      git status --short
      echo ""
      echo "Last commit:"
      git log -1 --oneline 2>/dev/null || true
      echo ""
      if git diff --quiet 2>/dev/null && git diff --cached --quiet 2>/dev/null; then
        echo "Working tree clean."
      else
        echo "Working tree has uncommitted changes."
      fi
    else
      echo "Not a git repository under $SKILLS_ROOT"
      echo "Using file-snapshot mode for VCS operations."
      echo "Skills present: $(find . -maxdepth 2 -name SKILL.md | wc -l)"
    fi
    ;;
  snapshot|commit)
    MSG="${2:-Manual snapshot $(date '+%Y-%m-%d %H:%M')}"
    if is_git_repo; then
      git add -A
      if git diff --cached --quiet; then
        echo "No changes to commit."
      else
        git commit -m "$MSG"
        echo "Snapshot committed: $MSG"
        git log -1 --oneline
      fi
    else
      file_snapshot "manual"
    fi
    ;;
  auto)
    REASON="${2:-orchestrator}"
    if is_git_repo; then
      if git diff --quiet 2>/dev/null && git diff --cached --quiet 2>/dev/null; then
        echo "Auto-snapshot skipped: working tree clean (reason: $REASON)"
        exit 0
      fi
      MSG=$(generate_smart_message "$REASON")
      git add -A
      if git diff --cached --quiet; then
        echo "No staged changes after add."
      else
        git commit -m "$MSG"
        echo "Auto-snapshot committed: $MSG"
        git log -1 --oneline
      fi
    else
      echo "Auto-snapshot (non-git): creating file snapshot (reason: $REASON)"
      file_snapshot "$REASON"
    fi
    ;;
  log)
    if is_git_repo; then
      git log --oneline -15
    else
      echo "Not a git repo — listing recent file snapshots:"
      ls -1t /home/workdir/artifacts/skill-vcs-snapshots/ 2>/dev/null | head -10 || echo "(none yet)"
    fi
    ;;
  diff)
    if is_git_repo; then
      git diff --stat HEAD
    else
      echo "Not a git repo — no diff available."
    fi
    ;;
  bisect)
    if ! is_git_repo; then
      echo "Bisect requires a git repository. Current root is not git-backed."
      exit 1
    fi
    shift
    case "${1:-help}" in
      start)
        BAD="${2:-HEAD}"
        GOOD="${3}"
        if [ -z "$GOOD" ]; then
          echo "Usage: $0 bisect start [bad-commit] <good-commit>"
          echo "Example: $0 bisect start HEAD e120dba"
          exit 1
        fi
        git bisect start
        git bisect bad "$BAD"
        git bisect good "$GOOD"
        echo "Bisect started. Current commit under test:"
        git log -1 --oneline
        ;;
      good)
        git bisect good
        ;;
      bad)
        git bisect bad
        ;;
      run)
        # Automated test loop: $0 bisect run "test-command"
        TEST_CMD="${2}"
        if [ -z "$TEST_CMD" ]; then
          echo "Usage: $0 bisect run \"test command that exits 0 on good, non-zero on bad\""
          echo "Example: $0 bisect run \"./scripts/test-demo-status.sh\""
          exit 1
        fi
        echo "Running automated bisect with test: $TEST_CMD"
        git bisect run bash -c "$TEST_CMD"
        ;;
      reset)
        git bisect reset
        echo "Bisect reset. Back on original branch."
        ;;
      log)
        git bisect log
        ;;
      status)
        git bisect visualize --oneline 2>/dev/null || git log --oneline -5
        ;;
      help|*)
        echo "Bisect subcommands:"
        echo "  bisect start [bad] <good>   Start bisect (default bad=HEAD)"
        echo "  bisect good                 Mark current as good"
        echo "  bisect bad                  Mark current as bad"
        echo "  bisect run \"test-cmd\"       Fully automated binary search"
        echo "  bisect reset                End bisect and return to branch"
        echo "  bisect log                  Show bisect decisions"
        echo "  bisect status               Show current state"
        ;;
    esac
    ;;
  help|--help|-h)
    echo "skill-vcs.sh — Skill ecosystem version control"
    echo "  status | snapshot|commit [msg] | auto [reason] | log | diff | bisect ..."
    echo "Graceful: if not a git repo, falls back to timestamped file snapshots under artifacts/skill-vcs-snapshots/"
    ;;
  *)
    echo "Unknown command: $1 (try: status | snapshot | auto | log | diff | bisect | help)"
    exit 1
    ;;
esac
