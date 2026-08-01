#!/bin/bash
# Skill Version Control Helper + Bisect Automation
# Beast Mode Skill Orchestrator - polished 2026-08-01
# Graceful: if not a git repo, falls back to timestamped file snapshots under artifacts/skill-vcs-snapshots/

SKILLS_ROOT="/home/workdir/.grok/skills"
ARTIFACTS="${ARTIFACTS:-/home/workdir/artifacts}"
SNAPSHOT_DIR="${ARTIFACTS}/skill-vcs-snapshots"

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

file_snapshot() {
  local reason="${1:-manual}"
  mkdir -p "$SNAPSHOT_DIR"
  local ts=$(date '+%Y%m%d-%H%M%S')
  local archive="${SNAPSHOT_DIR}/skills-snapshot-${ts}-${reason}.tar.gz"
  tar -czf "$archive" -C "$SKILLS_ROOT" . 2>/dev/null || true
  echo "File-snapshot created (non-git): $archive"
}

case "${1:-status}" in
  status)
    echo "=== Skill Ecosystem Git Status ==="
    if is_git_repo; then
      git status --short 2>/dev/null
      echo ""
      echo "Last commit:"
      git log -1 --oneline 2>/dev/null
      echo ""
      if git diff --quiet 2>/dev/null && git diff --cached --quiet 2>/dev/null; then
        echo "Working tree clean."
      else
        echo "Working tree has uncommitted changes."
      fi
    else
      echo "Not a git repository. File-snapshot mode active."
      echo "Snapshots live under: $SNAPSHOT_DIR"
      ls -1t "$SNAPSHOT_DIR" 2>/dev/null | head -5 || echo "(no snapshots yet)"
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
      echo "Not a git repository. Recent file snapshots:"
      ls -1t "$SNAPSHOT_DIR" 2>/dev/null | head -10 || echo "(none)"
    fi
    ;;
  diff)
    if is_git_repo; then
      git diff --stat HEAD
    else
      echo "Not a git repository — no diff available."
    fi
    ;;
  bisect)
    if ! is_git_repo; then
      echo "Bisect requires a git repository."
      exit 1
    fi
    shift
    case "${1:-help}" in
      start)
        BAD="${2:-HEAD}"
        GOOD="${3}"
        if [ -z "$GOOD" ]; then
          echo "Usage: $0 bisect start [bad-commit] <good-commit>"
          exit 1
        fi
        git bisect start
        git bisect bad "$BAD"
        git bisect good "$GOOD"
        echo "Bisect started. Current commit under test:"
        git log -1 --oneline
        ;;
      good) git bisect good ;;
      bad) git bisect bad ;;
      run)
        TEST_CMD="${2}"
        if [ -z "$TEST_CMD" ]; then
          echo "Usage: $0 bisect run \"test command\""
          exit 1
        fi
        git bisect run bash -c "$TEST_CMD"
        ;;
      reset) git bisect reset; echo "Bisect reset." ;;
      log) git bisect log ;;
      status) git bisect visualize --oneline 2>/dev/null || git log --oneline -5 ;;
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
