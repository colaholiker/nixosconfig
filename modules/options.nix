{ lib, ... }:

{
  options.local.features = {
    xserver = lib.mkEnableOption "X11/Xserver desktop environment";
    wayland = lib.mkEnableOption "Wayland display server";
    plasma6 = lib.mkEnableOption "KDE Plasma 6 desktop environment";
    networking = lib.mkEnableOption "networking tools";
    games = lib.mkEnableOption "gaming software";
    office = lib.mkEnableOption "office, documentation and diagram tools";
    dev = lib.mkEnableOption "development tools and IDEs";
    communication = lib.mkEnableOption "messenger and mail clients";
    emacs = lib.mkEnableOption "Emacs daemon";
    deskflow = lib.mkEnableOption "Deskflow keyboard/mouse sharing";
    vmwareHost = lib.mkEnableOption "VMware host virtualisation";
    docker = lib.mkEnableOption "Docker container runtime";
    winboat = lib.mkEnableOption "Winboat tools";
    virtualbox = lib.mkEnableOption "VirtualBox virtualisation";
    libvirt = lib.mkEnableOption "libvirt virtualisation";
  };

  options.local.userExtraGroups = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "Additional groups for user colaholiker contributed by feature modules.";
  };

}