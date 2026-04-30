{ config, lib, pkgs, ... }:
let
  cfg = config.local.features;
  winboatpkgs = with pkgs; [
    winboat
  ];
in
{
  local.userExtraGroups =
    lib.optionals cfg.docker [ "docker" ]
    ++ lib.optionals cfg.libvirt [ "libvirtd" ]
    ++ lib.optionals cfg.virtualbox [ "vboxusers" ];

  virtualisation.vmware.host.enable = cfg.vmwareHost;

  virtualisation.virtualbox.host = {
    enable = cfg.virtualbox;
    enableExtensionPack = true;
  };

  virtualisation.libvirtd.enable = cfg.libvirt;

  virtualisation.docker.enable = cfg.docker;
  environment.systemPackages =
    lib.optional cfg.winboat pkgs.winboat
    ++ lib.optionals cfg.docker [
      pkgs.ddev
      pkgs.mkcert
    ];

# 3. Allow Xdebug traffic (optional, for debugging)
  networking.firewall.allowedTCPPorts = [ 9003 ];

  # 4. Allow DDEV to modify the hosts file
  environment.etc.hosts.mode = "0644";

}