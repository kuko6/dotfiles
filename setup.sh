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
link "$(pwd)/config/helix" ~/.config/helix
link "$(pwd)/config/nvim" ~/.config/nvim
link "$(pwd)/config/btop" ~/.config/btop
link "$(pwd)/config/tmux" ~/.config/tmux
link "$(pwd)/config/ghostty" ~/.config/ghostty
link "$(pwd)/config/zed" ~/.config/zed

link "$(pwd)/config/bat" ~/.config/bat
bat cache --build

# mkdir -p "$"$(pwd)/config/bat/themes""
# if [ -e "$"$(pwd)/config/bat/themes/rose-pine-moon.tmTheme"" ]; then
#   echo "Bat theme already exists"
# else
#   curl -o "$"$(pwd)/config/bat/themes/rose-pine-moon.tmTheme"" \
#     "https://raw.githubusercontent.com/rose-pine/tm-theme/main/dist/rose-pine-moon.tmTheme"
#   bat cache --build
# fi

# TODO:
# - probably differentiate if its on home computer or work because the paths are different
# - I guess we can use hostname or set and ENV variable in .zshrc
link "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Obsidian/Kuko's Vault/" ~/Notes

link "$(pwd)/bin/daily_note.sh" ~/.local/bin/standup
