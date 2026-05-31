#!/usr/bin/env bash
# Install the cognitive-load skill for Claude Code.
#
#   ./install.sh            Install for the current user (~/.claude/skills)
#   ./install.sh --project  Install into ./.claude/skills of the current repo
#   ./install.sh --copy     Copy files instead of symlinking
#
# Symlink is the default so `git pull` in this repo updates the installed skill.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NAME="cognitive-load"

DEST_BASE="$HOME/.claude/skills"
MODE="symlink"

for arg in "$@"; do
  case "$arg" in
    --project) DEST_BASE="$(pwd)/.claude/skills" ;;
    --copy)    MODE="copy" ;;
    -h|--help)
      grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done

DEST="$DEST_BASE/$NAME"
mkdir -p "$DEST_BASE"

if [ -e "$DEST" ] || [ -L "$DEST" ]; then
  echo "Removing existing install at $DEST"
  rm -rf "$DEST"
fi

if [ "$MODE" = "symlink" ]; then
  ln -s "$SRC" "$DEST"
  echo "Symlinked $DEST -> $SRC"
else
  mkdir -p "$DEST"
  cp "$SRC/SKILL.md" "$DEST/SKILL.md"
  echo "Copied SKILL.md to $DEST"
fi

echo "Done. Restart your Claude Code session to load the '$NAME' skill."
