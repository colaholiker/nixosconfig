{ config, lib, pkgs, ... }:
let
  jnlpApp = pkgs.adoptopenjdk-icedtea-web;
  javawsWrapper = pkgs.writeScriptBin "javaws" ''
    #!${pkgs.bash}/bin/bash
    export JAVAWS_BIN="${jnlpApp}/bin/javaws"
    export PATH="${pkgs.jdk8}/bin:$PATH"
    export JAVA_HOME="${pkgs.jdk8}"
    echo "DEBUG: Verwende Java: $(${pkgs.jdk8}/bin/java -version 2>&1 | head -n 1)"
    exec "$JAVAWS_BIN" "$@"
  '';
  apppkgs = with pkgs; [
    audacity
    alacritty
    camunda-modeler
    freefilesync
    inkscape
    libreoffice-fresh
    #librecad
    #qcad
    qdirstat
    drawio
    github-desktop
    google-chrome
    kitty
    #kicad
    mpv
    meld
    gpu-viewer
    gparted
    vscode
    gimp3
    yed
    virt-manager
    virt-viewer
    remmina
    obsidian
    veracrypt
    vlc
    jetbrains.phpstorm
  ];
  clipkgs = with pkgs; [
    alsa-utils
    aspell
    aspellDicts.de
    aspellDicts.en
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
    broot
    plantuml
    dysk
    #minicom depency lrzsz is broken
    fwupd
    git
    git-lfs
    mesa-demos
    nvd
    htop
    nvtopPackages.full
    oh-my-posh
    i7z
    killall
    nixfmt
    nixos-generators
    pciutils
    ranger
    glances
    rclone
    hexyl
    unzip
    usbutils
    wget
    texliveFull
    yt-dlp
    yewtube
    testdisk
    exfat
    exfatprogs
    deskflow
	vim
  ];
  communicationpkgs = with pkgs; [
    signal-desktop
    ferdium
    discord
    hexchat
    libsForQt5.qt5.qtwebengine # aus kompatibilitätsgründen mit collect-garbage? need to watch ... dependency von teamspeak3
    teamspeak3
  ];
  devpackages = with pkgs; [ cmake automake python3 ghc nodePackages.nodejs ];
in
{
  imports = [
    ./networking.nix
    ./games.nix
  ];
  environment.systemPackages = apppkgs ++ clipkgs ++ communicationpkgs ++ devpackages ++ [ javawsWrapper ];
  programs.vscode = {
    enable = true;
  };
  programs.java = {
    enable = true;
  };
  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };
  programs.git = {
    enable = true;
  };
  programs.evolution = {
    enable = true;
  };
  programs.direnv = {
    enable = true;
  };
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
    ];
  };
  programs.noisetorch = {
    enable = true;
  };

  services.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
  };
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
