{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  networking.hostName = "qemu";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  services.openssh.enable = true;

  fileSystems."/mnt/xfer" = {
    device = "xfer";
    fsType = "virtiofs";
    options = [ "rw" "nofail" ];
  };

  system.stateVersion = "26.05";
}
