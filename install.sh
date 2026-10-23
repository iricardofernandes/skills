#!/usr/bin/env bash
# Install the craft plugin and link the global CLAUDE.md.
# Usage: ./install.sh [--local]   (--local installs from this checkout instead of GitHub)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
SOURCE="iricardofernandes/skills"
[ "${1:-}" = "--local" ] && SOURCE="$ROOT"

claude plugin marketplace add "$SOURCE"
claude plugin install craft@skills

target="$CLAUDE_DIR/CLAUDE.md"
if [ -e "$target" ] && [ ! -L "$target" ]; then
  backup="$target.bak-$(date +%Y%m%d%H%M%S)"
  mv "$target" "$backup"
  echo "Existing CLAUDE.md moved to $backup"
fi
ln -sfn "$ROOT/global/CLAUDE.md" "$target"
echo "Linked $target -> $ROOT/global/CLAUDE.md"
