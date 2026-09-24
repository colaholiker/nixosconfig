{ config, lib, pkgs, ... }:
let
  cfg = config.local.features;
  plasmapkgs = with pkgs; [
    kdePackages.yakuake
    kdePackages.filelight
    kdePackages.partitionmanager
    kdePackages.ksystemlog
    kdePackages.krdc
    # BROKEN
    #kdePackages.umbrello
    kdePackages.marble
    kdePackages.krohnkite
    kdePackages.kalgebra
    kdePackages.sddm-kcm
  ];
in
{
  config = lib.mkMerge [
    (lib.mkIf cfg.wayland {
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
    })

    (lib.mkIf cfg.plasma6 {
      services.desktopManager.plasma6.enable = true;
      environment.systemPackages = plasmapkgs;
    })
  ];
}
