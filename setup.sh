#!/bin/bash

# https://github.com/caarlos0/dotfiles/blob/main/setup
set -euo pipefail

link() {
  mkdir -p "$(dirname "$2")"
  if [ -e "$2" ]; then
    echo "Skipping $2, already exists."
  else
    ln -sf "$1" "$2"
    echo "Linked $1 to $2"
  fi
}

# create symlinks
link "$(pwd)/helix" ~/.config/helix
link "$(pwd)/nvim" ~/.config/nvim
link "$(pwd)/btop" ~/.config/btop
link "$(pwd)/tmux" ~/.config/tmux
link "$(pwd)/ghostty" ~/.config/ghostty
link "$(pwd)/zed" ~/.config/zed
