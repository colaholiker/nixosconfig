{ config, lib, pkgs, ... }:
let
  cfg = config.local.features;
in
{
  assertions = [
    {
      assertion = cfg.winboat -> cfg.docker;
      message = "local.features.winboat benötigt local.features.docker";
    }
  ];

  local.userExtraGroups =
    lib.optionals cfg.docker [ "docker" ]
    ++ lib.optionals cfg.libvirt [ "libvirtd" ]
    ++ lib.optionals cfg.virtualbox [ "vboxusers" ];

  virtualisation.vmware.host.enable = cfg.vmwareHost;

  virtualisation.virtualbox.host = {
    enable = cfg.virtualbox;
    # true = USB 2/3, RDP, Disk-Encryption; baut VirtualBox aus dem Quellcode (lange Builds)
    enableExtensionPack = false;
  };

  virtualisation.libvirtd.enable = cfg.libvirt;
  programs.virt-manager.enable = cfg.libvirt;
  virtualisation.spiceUSBRedirection.enable = cfg.libvirt;

  virtualisation.docker = {
    enable = cfg.docker;
    autoPrune.enable = true;
  };

  environment.systemPackages =
    lib.optional cfg.winboat pkgs.winboat
    ++ lib.optional cfg.libvirt pkgs.virt-viewer
    ++ lib.optionals cfg.docker [
      pkgs.ddev
      pkgs.mkcert
    ];

  # Xdebug: Verbindung aus den DDEV-Containern zum Host
  networking.firewall.allowedTCPPorts = lib.optionals cfg.docker [ 9003 ];
}
