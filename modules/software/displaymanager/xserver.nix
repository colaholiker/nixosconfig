{ config, lib, pkgs, ... }:
let
  cfg = config.local.features;
  # Nur verwenden, wenn die Datei im Repo (git) liegt, sonst eigene ~/.xmonad/xmonad.hs
  xmonadConfigFile = ../../../sources/xmonad/xmonad.hs;
  xmonadConfig = if builtins.pathExists xmonadConfigFile then xmonadConfigFile else null;
  xsupportpkgs = with pkgs; [
    xorg.xinput
    xorg.xmodmap
    xorg.xbacklight
    arandr
  ];
  xmonadpkgs = with pkgs; [
    feh
    conky
    dzen2
    dmenu
    dunst
    caffeine-ng
    haskellPackages.xmobar
    i3lock-fancy
    lxappearance
    mate.caja
    networkmanagerapplet
    redshift
    rofi
    stalonetray
    trayer
    xss-lock
  ];
in
{
  services.xserver = {
    enable = cfg.xserver;
    enableCtrlAltBackspace = true;

    windowManager.xmonad = {
      enable = config.services.xserver.enable;  # Abhängig von enable machen
      enableContribAndExtras = true;
      enableConfiguredRecompile = xmonadConfig != null;
      config = xmonadConfig;
    };
  };

  services.picom = {
    enable = config.services.xserver.enable;  # Abhängig von enable machen
    opacityRules = [
      "80:class_g = 'Alacritty' && focused"
      "80:class_g = 'Alacritty' && !focused"
    ];
  };

  # only add these packages when the X server is enabled
  environment.systemPackages = lib.optionals config.services.xserver.enable (xsupportpkgs ++ xmonadpkgs);
}