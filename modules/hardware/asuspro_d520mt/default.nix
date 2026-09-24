{ config, lib, pkgs, ... }:
let
  # Extra Graphics Packages for the asuspro hardware as installed hardware modules
  extragfxpkgs = with pkgs; [
    intel-media-driver
    libvdpau-va-gl
  ];
in
{
  imports = [
    ./boot.nix
    ./hardware-configuration.nix
    ./powermgmt.nix
  ];
  
  # Additional filesystems supported by the system
  #boot.supportedFilesystems = [ "zfs" ];
  #boot.zfs.allowHibernation = true;
  boot.tmp.cleanOnBoot = true;

  # i5-6400 (Skylake), HD Graphics 530 (i915), 4 GB RAM, SATA-SSD
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages = extragfxpkgs;

  # Nur 4 GB RAM: komprimierter Swap im RAM vor dem Swap auf der SSD
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
  # Beendet bei Speichermangel den größten Prozess, bevor das System einfriert
  services.earlyoom = {
    enable = true;
    enableNotifications = true;
  };

  # Rebuilds nicht parallel und mit niedriger Priorität, damit der Desktop bedienbar bleibt
  nix.settings.max-jobs = 1;
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";

}