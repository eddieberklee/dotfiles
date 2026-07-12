#!/bin/sh
# Symlink Codex global configuration files to the repo copies (single source
# of truth).
set -e
mkdir -p ~/.codex
ln -sf ~/dotfiles/ai/codex/memory.md ~/.codex/memory.md
ln -sf ~/dotfiles/ai/codex/hooks.json ~/.codex/hooks.json
echo "Linked ~/.codex/memory.md -> dotfiles/ai/codex/memory.md"
echo "Linked ~/.codex/hooks.json -> dotfiles/ai/codex/hooks.json"
