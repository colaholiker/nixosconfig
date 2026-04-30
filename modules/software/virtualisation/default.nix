{ config, lib, pkgs, ... }:
let
  cfg = config.local.features;
in
{
  local.userExtraGroups =
    lib.optionals cfg.docker [ "docker" ]
    ++ lib.optionals cfg.libvirt [ "libvirtd" ]
    ++ lib.optionals cfg.virtualbox [ "vboxusers" ];

  virtualisation = {
    vmware.host.enable = cfg.vmwareHost;

    virtualbox.host = {
      enable = cfg.virtualbox;
      enableExtensionPack = true;
    };

    libvirtd.enable = cfg.libvirt;

    docker = {
      enable = cfg.docker;
      daemon.settings = {
        # Docker benötigt diese Struktur für IP-Pools
        "default-address-pools" = [
          {
            base = "172.200.0.0/16";
            size = 24;
          }
        ];
      };
    };
  };

  # Direktere Zuweisung der Pakete
  environment.systemPackages = lib.mkIf cfg.winboat [ pkgs.winboat ];
}
