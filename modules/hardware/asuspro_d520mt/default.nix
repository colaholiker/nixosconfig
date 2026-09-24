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
  # Additional Kernel Modules for the initrd (available during boot)
  boot.initrd.availableKernelModules = [ "nvme" ];
  #boot.zfs.allowHibernation = true;

  hardware.graphics.enable = true;  # Before 24.11: hardware.opengl.driSupport
  hardware.graphics.enable32Bit = true;  # Before 24.11: hardware.opengl.driSupport32Bit
  hardware.graphics.extraPackages = extragfxpkgs;


}