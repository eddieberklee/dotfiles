#!/bin/sh
# Symlink Codex global memory to the repo copy (single source of truth).
set -e
mkdir -p ~/.codex
ln -sf ~/dotfiles/ai/codex/memory.md ~/.codex/memory.md
echo "Linked ~/.codex/memory.md -> dotfiles/ai/codex/memory.md"
