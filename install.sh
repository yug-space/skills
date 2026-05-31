#!/usr/bin/env bash
# Install skills from this repo for Claude Code (or any agent that reads ~/.claude/skills).
#
#   ./install.sh <name>            Install skills/<name> for the current user (~/.claude/skills)
#   ./install.sh <name> --project  Install into ./.claude/skills of the current repo
#   ./install.sh --all             Install every skill under skills/
#   ./install.sh <name> --copy     Copy files instead of symlinking
#
# Symlink is the default so `git pull` in this repo updates installed skills.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SRC/skills"

DEST_BASE="$HOME/.claude/skills"
MODE="symlink"
ALL=false
NAME=""

for arg in "$@"; do
  case "$arg" in
    --project) DEST_BASE="$(pwd)/.claude/skills" ;;
    --copy)    MODE="copy" ;;
    --all)     ALL=true ;;
    -h|--help) grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*)        echo "Unknown option: $arg" >&2; exit 1 ;;
    *)         NAME="$arg" ;;
  esac
done

install_one() {
  local name="$1"
  local src="$SKILLS_DIR/$name"
  local dest="$DEST_BASE/$name"
  if [ ! -f "$src/SKILL.md" ]; then
    echo "No skill named '$name' (expected $src/SKILL.md)" >&2; exit 1
  fi
  mkdir -p "$DEST_BASE"
  [ -e "$dest" ] || [ -L "$dest" ] && rm -rf "$dest"
  if [ "$MODE" = "symlink" ]; then
    ln -s "$src" "$dest"; echo "Symlinked $dest -> $src"
  else
    mkdir -p "$dest"; cp "$src/SKILL.md" "$dest/SKILL.md"; echo "Copied $name to $dest"
  fi
}

if [ "$ALL" = true ]; then
  for d in "$SKILLS_DIR"/*/; do install_one "$(basename "$d")"; done
elif [ -n "$NAME" ]; then
  install_one "$NAME"
else
  echo "Usage: ./install.sh <skill-name> | --all   (see --help)" >&2
  echo "Available:"; for d in "$SKILLS_DIR"/*/; do echo "  - $(basename "$d")"; done
  exit 1
fi

echo "Done. Restart your Claude Code session to load the skill(s)."
