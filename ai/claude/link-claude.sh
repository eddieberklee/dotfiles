#!/bin/sh
# Symlink the global Claude Code memory file to the repo copy (single source of truth).
set -e
mkdir -p ~/.claude
ln -sf ~/dotfiles/ai/claude/CLAUDE.md ~/.claude/CLAUDE.md
echo "Linked ~/.claude/CLAUDE.md -> dotfiles/ai/claude/CLAUDE.md"
