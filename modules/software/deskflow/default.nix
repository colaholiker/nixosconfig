{ config, lib, pkgs, ... }:

lib.mkIf config.local.features.deskflow {
  environment.systemPackages = [ pkgs.deskflow ];
  networking.firewall.allowedTCPPorts = [ 24800 ];
}
