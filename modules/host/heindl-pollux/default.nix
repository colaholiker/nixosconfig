{ config, lib, pkgs, ... }:

{
  imports = [
    ../../hardware/asuspro_d520mt
    ../../hardware/keyboard
  ];
  #boot.kernelPackages = pkgs.linuxPackages_6_18;

  networking = {
    hostName = "heindl-pollux";
    networkmanager.enable = true;
    usePredictableInterfaceNames = true;
    #proxy = {
      #default = "http://user:password@proxy:port/";
      #noProxy = "127.0.0.1,localhost,internal.domain";
    #};
    firewall.enable = true;
  };
}