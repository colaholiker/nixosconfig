{ config, lib, pkgs, ... }:
let

in
{
  time.timeZone = "Europe/Berlin";

  i18n = {
    defaultLocale = "de_DE.UTF-8"; # Die Sprache der Menüs
    extraLocales = [
      "de_DE.UTF-8/UTF-8"
      "de_AT.UTF-8/UTF-8"
      "de_CH.UTF-8/UTF-8"
      "de_LU.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "en_GB.UTF-8/UTF-8"
      "en_AU.UTF-8/UTF-8"
      "en_CA.UTF-8/UTF-8"
      "en_NZ.UTF-8/UTF-8"
      "en_IE.UTF-8/UTF-8"
      "en_ZA.UTF-8/UTF-8"
    ];
    # alle LC_* folgen defaultLocale (de_DE: Komma, Euro, A4, 24h, metrisch)
  };
  console.keyMap = "de";
  services.xserver.xkb.layout = "de";

}