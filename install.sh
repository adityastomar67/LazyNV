#!/bin/sh

NEOVIM_DIR=$HOME/.config/nvim
export NEOVIM_DIR

## Back up current config
[ -d $NEOVIM_DIR ] && mv $NEOVIM_DIR "$NEOVIM_DIR.backup"

## Optional but recommended
[ -d "$HOME/.local/share/nvim" ] && mv "$HOME/.local/share/nvim" "$HOME/.local/share/nvim.backup"
[ -d "$HOME/.local/state/nvim" ] && mv "$HOME/.local/state/nvim" "$HOME/.local/state/nvim.backup"
[ -d "$HOME/.cache/nvim" ]       && mv "$HOME/.cache/nvim" "$HOME/.cache/nvim.backup"

# Create config directory
mkdir -p $NEOVIM_DIR
git clone https://github.com/adityastomar67/LazyNV.git $NEOVIM_DIR

# Remove git related files
rm -rf ~/.config/nvim/.git

## Run Neovim for the initial setup
cd $HOME && nvim