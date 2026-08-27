{
  wayland.windowManager.sway = {
    enable = true;
    package = null; # NixOS programs.sway owns the package
    wrapperFeatures.gtk = true;
    config = {
      modifier = "Mod4";
      terminal = "ghostty";
      menu = "fuzzel";
      bars = [ ];
      input."type:keyboard".xkb_layout = "us";
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };

  programs.fuzzel.enable = true;
  programs.mako.enable = true;
  programs.ghostty.enable = true;
  programs.firefox.enable = true;
}
