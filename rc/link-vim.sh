#!/bin/sh
# Point vim and neovim at the shared vimrc in this repo (single source of truth).
# Unlike copy-zshrc.sh this symlinks/sources, so edits to the repo take effect live.

set -e

# vim: ~/.vimrc -> repo
ln -sf ~/dotfiles/rc/vimrc_universal ~/.vimrc

# neovim: init.vim sources the same repo file
mkdir -p ~/.config/nvim
cat > ~/.config/nvim/init.vim << 'NVIM'
" Reuse the shared vim config from dotfiles as the single source of truth.
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/dotfiles/rc/vimrc_universal
NVIM

echo "Linked ~/.vimrc and ~/.config/nvim/init.vim to dotfiles/rc/vimrc_universal"
