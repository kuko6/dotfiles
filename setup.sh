#!/bin/bash

# https://github.com/caarlos0/dotfiles/blob/main/setup
set -euo pipefail

link() {
  # check if the command exists
  local cmd="${3:-}"
  if [ -n "$cmd" ]; then
    if ! command -v "$cmd" >/dev/null 2>&1; then
      echo "Skipping config for '$cmd', not found."
      return 0
    fi
  fi

  # link the config directory
  mkdir -p "$(dirname "$2")"
  if [ -e "$2" ]; then
    echo "Skipping $2, already exists."
  else
    ln -sf "$1" "$2"
    echo "Linked $1 to $2"
  fi
}

# copy zsh config
if [ ! -e ~/.zshrc.local ]; then
  cp ~/.zshrc ~/.zshrc.local
  cp -f "$(pwd)/.zshrc" ~/.zshrc
else
  echo "~/.zshrc has already been copied"
fi

# create symlinks
link "$(pwd)/config/helix" ~/.config/helix "hx"
link "$(pwd)/config/nvim" ~/.config/nvim "nvim"
link "$(pwd)/config/btop" ~/.config/btop "btop"
link "$(pwd)/config/tmux" ~/.config/tmux "tmux"
link "$(pwd)/config/ghostty" ~/.config/ghostty "ghostty"
link "$(pwd)/config/zed" ~/.config/zed "zed"

# special case for bat
link "$(pwd)/config/bat" ~/.config/bat "bat"

if command -v bat >/dev/null 2>&1; then
  mkdir -p "$(pwd)/config/bat/themes"
  if [ -e "$(pwd)/config/bat/themes/rose-pine-moon.tmTheme" ]; then
    echo "Bat theme already exists"
  else
    curl -o "$(pwd)/config/bat/themes/rose-pine-moon.tmTheme" \
      "https://raw.githubusercontent.com/rose-pine/tm-theme/main/dist/rose-pine-moon.tmTheme"
    bat cache --build
  fi
fi

# create shortcut for obsidian vault
if [[ "$(uname)" == "Darwin" ]]; then
  case "$(hostname)" in
    Kukov-MacBook-Air*)
      link "$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Kuko's Vault/" ~/Notes
      ;;
    *)
      link "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Obsidian/Kuko's Vault/" ~/Notes
      ;;
  esac
fi

link "$(pwd)/bin/daily_note.sh" ~/.local/bin/standup
