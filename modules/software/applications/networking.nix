{
  config,
  lib,
  pkgs,
  ...
}:
let
  gnspkgs = with pkgs; [
    gns3-gui
    #ciscoPacketTracer8
  ];
  networkingpkgs = with pkgs; [
    arp-scan
    ethtool
    ipcalc
    netcat-gnu
    inetutils
    iputils
    iptraf-ng
    kismet
    nbtscan
    netdiscover
    #netsniff-ng BROKEN
    nmap
    whois
    #nomachine-client
    zenmap
  ];
 in
lib.mkIf config.local.features.networking
{
  #nixpkgs.overlays = [
  #  (import ../../../overlays/ciscoPacketTracer8)
  #];
  environment.systemPackages = gnspkgs ++ networkingpkgs;

  programs.wireshark = {
    enable = true;
    dumpcap.enable = true;
    usbmon.enable = true;
    package = pkgs.wireshark;
  };
  local.userExtraGroups = [ "wireshark" ];

  programs.iftop.enable = true;

  programs.mtr.enable = true;
}