{ config, pkgs, lib, ... }:
let

in
{
  home.stateVersion = "25.11";
  programs.mpv = {
    enable = true;
    config = {
      gpu-context = "wayland";
      hwdec = "vaapi"; # maybe vulkan in the future
    };
  };

  home.sessionVariables = {
    # DICPATH sagt Hunspell, wo die Wörterbücher liegen
    DICPATH = "/etc/profiles/per-user/${config.home.username}/share/hunspell:/run/current-system/sw/share/hunspell";

    # ASPELL_CONF setzt die Standard-Sprache für Aspell
    ASPELL_CONF = "lang de_DE";
  };

}