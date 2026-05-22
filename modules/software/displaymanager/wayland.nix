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
  services.displayManager.sddm = {
    enable = cfg.wayland;
    wayland.enable = true;
  };

  services.desktopManager.plasma6 = {
    enable = cfg.plasma6;
  };

 xdg.portal = {
     enable = true;
     extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
     # Optionale Angabe für Plasma 6 Priorität
     config.common.default = "kde";
   };

  environment.systemPackages = lib.optionals cfg.plasma6 plasmapkgs;
}