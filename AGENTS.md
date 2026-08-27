# AGENTS.md

NixOS + Home Manager. Future primary, not a toy.

```bash
sudo nixos-rebuild switch --flake .#qemu
```

## Old dots (catalog)

On this machine: `~/Projects/archlinux-dotfiles`  
GitHub: <https://github.com/bergheim/dotfiles>

Catalog, not a dump. 15 years of Arch. Look there when porting one program, then write a Nix/HM module. Do not copy trees.

## Tmux

`modules/home/tmux.nix` is the catalog `.tmux.conf` as HM. Plugins via `pkgs.tmuxPlugins` (no TPM). Fuzzy scripts are store paths. `ta` is in `zsh.nix`.

Not ported: emacs Ghostty theme hooks (no Emacs in v1). Status uses  not .
