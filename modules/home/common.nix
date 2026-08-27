{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "bergheim";
    userEmail = "bergheim@users.noreply.github.com";
  };

  programs.neovim.enable = true;

  home.packages = with pkgs; [
    fd
    ripgrep
    nodejs_24
    pnpm
  ];

  home.sessionVariables.PNPM_HOME = "/home/tsb/.local/share/pnpm";
  home.sessionPath = [ "/home/tsb/.local/share/pnpm/bin" ];
}
