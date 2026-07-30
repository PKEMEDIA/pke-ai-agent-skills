#!/usr/bin/env bash
# Exclusive heal lease for multi-process COVICEA / PKE self-heal.
# Prevents split-brain when autonomous-worker, orchestrator-self-heal,
# grok-watch, and repair-agents all try to restart the same service.
#
# Usage:
#   source heal-lease.sh
#   if heal_lease_acquire "compile-studio" "autonomous-worker" 60; then
#     # ... perform heal ...
#     heal_lease_release "compile-studio" "autonomous-worker"
#   else
#     echo "another healer holds the lease"
#     exit 0
#   fi
#
# Standalone:
#   bash heal-lease.sh acquire <target> <holder> [ttl_sec]
#   bash heal-lease.sh release <target> <holder>
#   bash heal-lease.sh status  <target>

set -euo pipefail

HEAL_LEASE_DIR="${HEAL_LEASE_DIR:-${HOME:-/tmp}/Library/Logs/covicea-heal-leases}"
mkdir -p "$HEAL_LEASE_DIR"

_heal_lease_path() {
  local target="$1"
  local hash
  hash=$(printf '%s' "$target" | shasum -a 1 2>/dev/null | awk '{print $1}' | cut -c1-12)
  echo "$HEAL_LEASE_DIR/lease-${hash}.json"
}

_heal_now() { date +%s; }

# Returns 0 if lease acquired, 1 if held by another.
heal_lease_acquire() {
  local target="${1:?target required}"
  local holder="${2:?holder required}"
  local ttl="${3:-60}"
  local path now expires existing_holder existing_exp
  path=$(_heal_lease_path "$target")
  now=$(_heal_now)
  expires=$((now + ttl))

  if [[ -f "$path" ]]; then
    existing_holder=$(python3 -c "import json,sys; d=json.load(open(sys.argv[1])); print(d.get('holderId',''))" "$path" 2>/dev/null || echo "")
    existing_exp=$(python3 -c "import json,sys; d=json.load(open(sys.argv[1])); print(int(d.get('expiresAt',0)))" "$path" 2>/dev/null || echo "0")
    if [[ -n "$existing_holder" && "$existing_exp" -gt "$now" && "$existing_holder" != "$holder" ]]; then
      echo "LEASE_HELD holder=$existing_holder expires=$existing_exp target=$target" >&2
      return 1
    fi
  fi

  python3 - "$path" "$holder" "$target" "$expires" "$now" <<'PY'
import json, sys
path, holder, target, expires, now = sys.argv[1:6]
data = {
    "holderId": holder,
    "target": target,
    "expiresAt": int(expires),
    "acquiredAt": int(now),
    "epoch": int(now),
}
with open(path, "w") as f:
    json.dump(data, f, indent=2)
print(f"LEASE_ACQUIRED holder={holder} target={target} ttl_until={expires}")
PY
  return 0
}

heal_lease_release() {
  local target="${1:?target required}"
  local holder="${2:?holder required}"
  local path existing_holder
  path=$(_heal_lease_path "$target")
  if [[ ! -f "$path" ]]; then
    echo "LEASE_ABSENT target=$target"
    return 0
  fi
  existing_holder=$(python3 -c "import json,sys; d=json.load(open(sys.argv[1])); print(d.get('holderId',''))" "$path" 2>/dev/null || echo "")
  if [[ "$existing_holder" != "$holder" && -n "$existing_holder" ]]; then
    echo "LEASE_REFUSE release by non-holder holder=$existing_holder requester=$holder" >&2
    return 1
  fi
  rm -f "$path"
  echo "LEASE_RELEASED target=$target holder=$holder"
  return 0
}

heal_lease_status() {
  local target="${1:?target required}"
  local path now
  path=$(_heal_lease_path "$target")
  now=$(_heal_now)
  if [[ ! -f "$path" ]]; then
    echo "LEASE_FREE target=$target"
    return 0
  fi
  python3 - "$path" "$now" <<'PY'
import json, sys
path, now = sys.argv[1], int(sys.argv[2])
d = json.load(open(path))
exp = int(d.get("expiresAt", 0))
if exp < now:
    print(f"LEASE_EXPIRED target={d.get('target')} holder={d.get('holderId')}")
else:
    print(f"LEASE_ACTIVE target={d.get('target')} holder={d.get('holderId')} expires={exp} remaining={exp-now}s")
PY
}

# CLI entry
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  cmd="${1:-}"
  case "$cmd" in
    acquire) heal_lease_acquire "${2:-}" "${3:-}" "${4:-60}" ;;
    release) heal_lease_release "${2:-}" "${3:-}" ;;
    status)  heal_lease_status "${2:-}" ;;
    *)
      echo "Usage: $0 acquire|release|status <target> [holder] [ttl_sec]" >&2
      exit 2
      ;;
  esac
fi
