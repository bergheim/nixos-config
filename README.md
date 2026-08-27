# nixos-config

NixOS in a QEMU VM, treated as the future primary — not a toy. Old dots at <https://github.com/bergheim/dotfiles> are a **catalog**, not a dump. Most of that is 15 years of Arch; ignore it. Re-add one program at a time, the NixOS + Home Manager way.

## Locked

| | |
| --- | --- |
| Layout | flakes + Home Manager as a NixOS module (one rebuild = system + user) |
| nixpkgs | `nixos-unstable` |
| Hosts | `hosts/<name>/` from day one. Only **qemu** exists. Next machine = new dir |
| Linux user | `tsb` |
| GitHub / git | `bergheim` / `bergheim@users.noreply.github.com` |
| Desktop | Sway, greetd+tuigreet, waybar, fuzzel, mako |
| v1 apps | zsh (HM plugins, no zim), ghostty, Firefox, Neovim |
| Secrets | none yet |

Config lives in this repo, not `/etc/nixos`:

```bash
sudo nixos-rebuild switch --flake .#qemu
```

Miss a tool → nix option or `home.packages` line → rebuild. That is the workflow.

## Not in v1

Emacs, qutebrowser, mu4e, pass, syncthing, themes, old `.zshrc`, niri/hypr/i3 leftovers.

## After v1 (package by package)

One module per thing, when you actually miss it.

1. git ssh + this repo on GitHub
2. first-week CLI — zoxide/fzf/atuin already in zsh.nix
3. Emacs as its own home module (packages first, init later)
4. qutebrowser
5. sops-nix when a second host or a real secret appears
6. next `hosts/<machine>/`

## Skip until it hurts

flake-parts, sops-nix, stylix, disko, impermanence.

Installer snapshot: `~/nixos-gen14-source`.
