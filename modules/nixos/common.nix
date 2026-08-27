{ pkgs, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nb_NO.UTF-8";
    LC_IDENTIFICATION = "nb_NO.UTF-8";
    LC_MEASUREMENT = "nb_NO.UTF-8";
    LC_MONETARY = "nb_NO.UTF-8";
    LC_NAME = "nb_NO.UTF-8";
    LC_NUMERIC = "nb_NO.UTF-8";
    LC_PAPER = "nb_NO.UTF-8";
    LC_TELEPHONE = "nb_NO.UTF-8";
    LC_TIME = "nb_NO.UTF-8";
  };

  services.xserver.xkb.layout = "us";
  console.useXkbConfig = true;

  programs.zsh.enable = true;

  users.users.tsb = {
    isNormalUser = true;
    description = "Thomas Bergheim";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
    ];
    shell = pkgs.zsh;
  };
}
