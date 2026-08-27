{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "bergheim";
    userEmail = "bergheim@users.noreply.github.com";
  };

  programs.neovim.enable = true;

  home.packages = with pkgs; [
    fd
    ripgrep
  ];
}
