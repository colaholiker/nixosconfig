{ config, lib, pkgs, ... }:
let
  # Extra Packages for the auspro hardware as installed packages
  extrapkgs = with pkgs; [
    intel-gpu-tools
    vdpauinfo
    libva-utils
    modem-manager-gui
  ];
  # Extra Graphics Packages for the Lenovo TP25 hardware as installed hardware modules
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
  boot.initrd.kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  # Additional Kernel Modules for the system
  boot.kernelModules = [ "kvm-intel" "vfio_pci" "vfio" "vfio_iommu_type1" ];
  boot.extraModulePackages = [ ];
  #boot.zfs.allowHibernation = true;


  services.avahi = {
    enable = true;
    openFirewall = true;
  };

  hardware.graphics.enable = true;  # Before 24.11: hardware.opengl.driSupport
  hardware.graphics.enable32Bit = true;  # Before 24.11: hardware.opengl.driSupport32Bit

  # Enable nvidia Optimus support and install extra hardware modules and or packages
  hardware.nvidiaOptimus.disable = false;
  hardware.graphics.extraPackages = extragfxpkgs;


}