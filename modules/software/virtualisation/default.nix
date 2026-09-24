{ config, lib, pkgs, ... }:
let
  cfg = config.local.features;
in
{
  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = cfg.winboat -> cfg.docker;
          message = "local.features.winboat benötigt local.features.docker";
        }
      ];
    }

    (lib.mkIf cfg.vmwareHost {
      virtualisation.vmware.host.enable = true;
    })

    (lib.mkIf cfg.virtualbox {
      virtualisation.virtualbox.host = {
        enable = true;
        # true = USB 2/3, RDP, Disk-Encryption; baut VirtualBox aus dem Quellcode (lange Builds)
        enableExtensionPack = false;
      };
      local.userExtraGroups = [ "vboxusers" ];
    })

    (lib.mkIf cfg.libvirt {
      virtualisation.libvirtd.enable = true;
      programs.virt-manager.enable = true;
      virtualisation.spiceUSBRedirection.enable = true;
      environment.systemPackages = [ pkgs.virt-viewer ];
      local.userExtraGroups = [ "libvirtd" ];
    })

    (lib.mkIf cfg.docker {
      virtualisation.docker = {
        enable = true;
        autoPrune.enable = true;
      };
      environment.systemPackages = [
        pkgs.ddev
        pkgs.mkcert
      ];
      local.userExtraGroups = [ "docker" ];
      # Xdebug: Verbindung aus den DDEV-Containern zum Host
      networking.firewall.allowedTCPPorts = [ 9003 ];
    })

    (lib.mkIf cfg.winboat {
      environment.systemPackages = [ pkgs.winboat ];
    })
  ];
}
