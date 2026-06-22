#!/bin/sh
# Auto-commit and push dotfiles changes. Safe to run repeatedly; no-op when clean.
cd ~/dotfiles || exit 0
[ -z "$(git status --porcelain)" ] && exit 0
git add -A
git commit -m "auto-sync: $(date '+%Y-%m-%d %H:%M:%S')" >/dev/null 2>&1
git pull --rebase --autostash origin master >/dev/null 2>&1
git push origin master >/dev/null 2>&1
