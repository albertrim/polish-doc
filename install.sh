#!/usr/bin/env bash
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/skill/polish-doc"
DEST_ROOT="$HOME/.claude/skills"
SCOPE="global (~/.claude/skills)"

if [[ "${1:-}" == "--project" ]]; then
  if [[ -z "${2:-}" ]]; then
    echo "Usage: ./install.sh --project /path/to/repo" >&2
    exit 1
  fi
  if [[ ! -d "$2" ]]; then
    echo "No such directory: $2" >&2
    exit 1
  fi
  DEST_ROOT="$2/.claude/skills"
  SCOPE="project ($2/.claude/skills)"
fi

DEST="$DEST_ROOT/polish-doc"

if [[ -d "$DEST" ]]; then
  echo "Already installed at: $DEST"
  read -r -p "Overwrite? [y/N] " ans
  [[ "$ans" =~ ^[Yy]$ ]] || { echo "Cancelled."; exit 0; }
  rm -rf "$DEST"
fi

mkdir -p "$DEST_ROOT"
cp -R "$SRC" "$DEST"

echo "Installed — $SCOPE"
echo
echo "  Start a new Claude Code session, then:"
echo "    /polish-doc <file path, or the content to document>"
echo
echo "  No Claude Code? See manual/PROMPT.md"
