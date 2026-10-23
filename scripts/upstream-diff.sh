#!/usr/bin/env bash
# Show what changed upstream since the commit each adapted file was synced from.
# Usage: scripts/upstream-diff.sh [local-name-filter]
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SOURCES="$ROOT/upstream/sources.tsv"
FILTER="${1:-}"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

clone() {
  local repo="$1" dir="$WORK/${1//\//_}"
  [ -d "$dir" ] || git clone --quiet --filter=blob:none "https://github.com/$repo" "$dir"
  echo "$dir"
}

grep -v '^#' "$SOURCES" | while IFS=$'\t' read -r local repo pin path; do
  [ -n "$FILTER" ] && [[ "$local" != *"$FILTER"* ]] && continue
  dir="$(clone "$repo")"
  log="$(git -C "$dir" log --oneline "$pin..HEAD" -- "$path")"
  if [ -z "$log" ]; then
    [ -n "$FILTER" ] && echo "$local: up to date with $repo"
    continue
  fi
  echo "== $local  ($repo:$path)"
  echo "$log"
  if [ -n "$FILTER" ]; then
    git -C "$dir" diff "$pin..HEAD" -- "$path"
  fi
  echo
done
