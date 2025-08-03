#!/bin/bash

# remove any existing symlinks/directories
rm -rf ~/.config/helix ~/.config/nvim ~/.config/btop ~/.config/tmux

# create fresh symlinks
ln -sf "$(pwd)/helix" ~/.config/helix
ln -sf "$(pwd)/nvim" ~/.config/nvim
ln -sf "$(pwd)/btop" ~/.config/btop
ln -sf "$(pwd)/tmux" ~/.config/tmux
