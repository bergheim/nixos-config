{
  imports = [
    ./common.nix
    ./desktop.nix
    ./zsh.nix
    ./tmux.nix
  ];

  home.username = "tsb";
  home.homeDirectory = "/home/tsb";
  home.stateVersion = "26.05";
}
