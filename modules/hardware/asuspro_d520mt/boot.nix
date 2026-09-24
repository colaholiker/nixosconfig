{ config, lib, pkgs, ... }:

{
  # Configuration of the Boot Loader
  boot.loader = {
    timeout = 3;
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
      memtest86.enable = true;
      netbootxyz.enable = true;
    };
    efi.canTouchEfiVariables = true;
  };
}