# About

My Neovim configuration packaged as a standalone Nix flake, based off of
[kickstart-nix.nvim](https://github.com/nix-community/kickstart-nix.nvim).

Everything is half-baked and I don't feel like working on this anymore. Most
notably the `native/` plugins. Will hopefully rewrite those at some point.

## Quick start

You need [Nix](https://nixos.org/nix) to be able to run this.

```bash
# TUI
nix run 'github:bodby/nvim-btw'

# Neovide wrapper
nix run 'github:bodby/nvim-btw#gui'
```
