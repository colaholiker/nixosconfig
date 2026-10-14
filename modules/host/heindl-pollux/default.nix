{ config, lib, pkgs, ... }:

{
  imports = [
    ../../hardware/asuspro_d520mt
  ];
  #boot.kernelPackages = pkgs.linuxPackages_6_18;

  networking = {
    hostName = "heindl-pollux";
    networkmanager.enable = true;
    # Split-DNS: Anfragen für fritz.box gehen über den Tunnel, alles andere über das lokale Netz
    networkmanager.dns = "systemd-resolved";
    usePredictableInterfaceNames = true;
    #proxy = {
      #default = "http://user:password@proxy:port/";
      #noProxy = "127.0.0.1,localhost,internal.domain";
    #};
    firewall.enable = true;
    # WireGuard über NetworkManager: strenger rpfilter verwirft sonst Pakete über den Tunnel
    firewall.checkReversePath = "loose";
    hosts = {
      "92.205.197.255" = [ "vw-ra.de" "www.vw-ra.de" ];
    };
  };

  services.resolved.enable = true;

  # WireGuard-Verbindungen verwaltet NetworkManager (nmcli connection import type wireguard file wg0.conf)
  environment.systemPackages = [ pkgs.wireguard-tools ];

  # Schlüssel liegen nicht im Repo, sondern lokal auf dem Host (root:root, 0600):
  #   WG_BIGTOWER_PRIVATE_KEY=...
  #   WG_BIGTOWER_PRESHARED_KEY=...
  networking.networkmanager.ensureProfiles = {
    environmentFiles = [ "/etc/nixos/secrets/wg-bigtower.env" ];
    profiles.wg-bigtower = {
      connection = {
        id = "wg-bigtower";
        type = "wireguard";
        interface-name = "wg-bigtower";
        autoconnect = true;
      };
      wireguard = {
        private-key = "$WG_BIGTOWER_PRIVATE_KEY";
      };
      "wireguard-peer.0Fiujx1NYW12dPFxjVw4b0WhYf2BA7kRM9zWXr8CD08=" = {
        endpoint = "po9ibyy3cx1nluwp.myfritz.net:50548";
        preshared-key = "$WG_BIGTOWER_PRESHARED_KEY";
        preshared-key-flags = 0;
        # Split-Tunnel: nur das Heimnetz über den Tunnel, Internet direkt
        allowed-ips = "172.16.0.0/16;fdca:ef84:2e09::/64;";
        persistent-keepalive = 25;
      };
      ipv4 = {
        method = "manual";
        address1 = "172.16.6.3/16";
        dns = "172.16.0.1;";
        dns-search = "fritz.box;";
      };
      ipv6 = {
        method = "manual";
        address1 = "fdca:ef84:2e09::3/64";
        dns = "fdca:ef84:2e09::52e6:36ff:fe72:bdb9;";
        dns-search = "fritz.box;";
        addr-gen-mode = "stable-privacy";
      };
    };
  };
}