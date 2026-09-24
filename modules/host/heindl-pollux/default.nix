{ config, lib, pkgs, ... }:

{
  imports = [
    ../../hardware/asuspro_d520mt
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
    # WireGuard über NetworkManager: strenger rpfilter verwirft sonst Pakete über den Tunnel
    firewall.checkReversePath = "loose";
  };

  # WireGuard-Verbindungen verwaltet NetworkManager (nmcli connection import type wireguard file wg0.conf)
  environment.systemPackages = [ pkgs.wireguard-tools ];
}