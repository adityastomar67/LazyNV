<div align = "center">

<h1><a href="https://github.com/adityastomar67/LazyNV">LazyNV</a> - LazyLoaded Neovim Config. ✨🛠</h1>

<a href="https://github.com/adityastomar67/LazyNV/blob/main/LICENSE">
<img alt="License" src="https://img.shields.io/github/license/adityastomar67/LazyNV?style=flat&color=eee&label="> </a>

<a href="https://github.com/adityastomar67/LazyNV/graphs/contributors">
<img alt="People" src="https://img.shields.io/github/contributors/adityastomar67/LazyNV?style=flat&color=ffaaf2&label=People"> </a>

<a href="https://github.com/adityastomar67/LazyNV/stargazers">
<img alt="Stars" src="https://img.shields.io/github/stars/adityastomar67/LazyNV?style=flat&color=98c379&label=Stars"></a>

<a href="https://github.com/adityastomar67/LazyNV/network/members">
<img alt="Forks" src="https://img.shields.io/github/forks/adityastomar67/LazyNV?style=flat&color=66a8e0&label=Forks"> </a>

<a href="https://github.com/adityastomar67/LazyNV/watchers">
<img alt="Watches" src="https://img.shields.io/github/watchers/adityastomar67/LazyNV?style=flat&color=f5d08b&label=Watches"> </a>

<a href="https://github.com/adityastomar67/LazyNV/pulse">
<img alt="Last Updated" src="https://img.shields.io/github/last-commit/adityastomar67/LazyNV?style=flat&color=e06c75&label="> </a>

<h3>Neovim Config for BlazingFast Users for BlazingFast Performance.💥</h3>

</div>

LazyNV is a `<utility/tool>` that allows `<target_audience>` to `<some_action>`.


## ✨ Features

- 🔥 Transform your Neovim into a full-fledged IDE
- 💤 Easily customize and extend your config with [lazy.nvim](https://github.com/folke/lazy.nvim)
- 🚀 Blazingly fast
- 🧹 Sane default settings for options, autocmds, and keymaps
- 📦 Comes with a wealth of plugins pre-configured and ready to use
- 🦾 Alot of ready to use Code Assistance features

## Setup


### ⚡ Requirements

- Neovim >= **0.8.0** (needs to be built with **LuaJIT**)
- Git >= **2.19.0** (for partial clones support)
- a [Nerd Font](https://www.nerdfonts.com/) **_(optional)_**

### 🚀 Installation

Create a `install.sh` file and paste the below content in that file.

```bash
NEOVIM_DIR=$HOME/.config/nvim
export NEOVIM_DIR

## Back up current config
[ -d $NEOVIM_DIR ] && mv $NEOVIM_DIR "$NEOVIM_DIR.backup"

## Optional but recommended
[ -d "$HOME/.local/share/nvim" ] && mv "$HOME/.local/share/nvim" "$HOME/.local/share/nvim.backup"
[ -d "$HOME/.local/state/nvim" ] && mv "$HOME/.local/state/nvim" "$HOME/.local/state/nvim.backup"
[ -d "$HOME/.cache/nvim" ]       && mv "$HOME/.cache/nvim"       "$HOME/.cache/nvim.backup"

# Create config directory
mkdir -p $NEOVIM_DIR
git clone https://github.com/adityastomar67/LazyNV.git $NEOVIM_DIR

# Remove git related files
rm -rf ~/.config/nvim/.git

## Run Neovim for the initial setup
cd $HOME && nvim
```
Now use `chmod +x install.sh` to make that file executable and then run it with the following command `./install.sh`<br> **Or you can use the below code snippet for complete automated install.**

```bash
curl -sL https://bit.ly/Fresh-Install | sh -s -- --LazyNV
```


### ✅ To-Do

- [x] Setup repo
- [ ] Think real hard
- [ ] Start typing


## Behind The Code


### 🌈 Inspiration

LazyNV was inspired by `LazyVim`.

<hr>

<div align="center">

<strong>⭐ hit the star button if you found this useful ⭐</strong><br>

<a href="https://github.com/adityastomar67/LazyNV">Source</a>
| <a href="https://github.com/adityastomar67/" target="_blank">GitHub </a>
| <a href="https://www.linkedin.com/in/aditya-singh-tomar-3200b31a0/" target="_blank">LinkedIn </a>
| <a href="https://linktr.ee/adityastomar67" target="_blank">LinkTree </a>

</div>
