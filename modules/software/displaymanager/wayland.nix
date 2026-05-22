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
   extraPortals = [ pkgs.xdg-desktop-portal-wlr ]; # Falls du Sway/Hyprland nutzt
   # extraPortals = [ pkgs.xdg-desktop-portal-gnome ]; # Falls du GNOME nutzt
 };

  environment.systemPackages = lib.optionals cfg.plasma6 plasmapkgs;
}