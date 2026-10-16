{ config, lib, pkgs, ... }:
let
  # Echte EDID des LG BK550Y (base64 von /sys/class/drm/card1-DP-1/edid, inkl. Audio-Block)
  lgEdid = pkgs.runCommand "edid-lg-bk550y" { } ''
    mkdir -p "$out/lib/firmware/edid"
    base64 -d > "$out/lib/firmware/edid/lg-bk550y.bin" <<'EOF'
    AP///////wAebUFby1AFAAceAQOAMBt46jE1pVVOoSYMUFSlSwBxT4GAlQCzAKnAgQCBwJBAAjqAGHE4LUBYLEUA4A4RAAAeAAAA/QA4Sx5TDwAKICAgICAgAAAA/ABCSzU1MFkKICAgICAgAAAA/wAwMDdOVENaQTgzNjMKAXsCAxvxSJAEAwEQEhMfIwkHB4MBAABlAwwAEAACOoAYcTgtQFgsRQDgDhEAAB4AAAAAAAAAAAAAAAAAAAAAAAABHQByUdAeIG4oVQDgDhEAAB6MCtCKIOAtEBA+lgDgDhEAABgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAig==
    EOF
  '';

  # Monitor-Konfiguration der Plasma-Sitzung (Kopie von ~/.config/kwinoutputconfig.json)
  kwinOutputConfig = ./kwinoutputconfig.json;
in
{
  # Beide Monitore hängen am KVM-Switch, der Hotplug/EDID nicht zuverlässig durchreicht:
  # Anschlüsse dauerhaft einschalten und die EDID des LG BK550Y vorgeben (beide Monitore gleich)
  hardware.display = {
    edid.packages = [ lgEdid ];
    outputs = lib.genAttrs [ "DP-1" "HDMI-A-2" ] (_: {
      edid = "lg-bk550y.bin";
      mode = "1920x1080@60e";
    });
  };

  # SDDM (KWin) soll dieselbe Monitor-Konfiguration wie die Plasma-Sitzung verwenden,
  # sonst rät KWin nach dem Umschalten des KVM-Switch die Auflösung
  systemd.tmpfiles.rules = lib.optionals (builtins.pathExists kwinOutputConfig) [
    "L+ /var/lib/sddm/.config/kwinoutputconfig.json - - - - ${kwinOutputConfig}"
  ];
}
