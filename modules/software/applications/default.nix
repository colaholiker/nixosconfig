{ config, lib, pkgs, ... }:
let
  cfg = config.local.features;
  jnlpApp = pkgs.adoptopenjdk-icedtea-web;
  javawsWrapper = pkgs.writeScriptBin "javaws" ''
    #!${pkgs.bash}/bin/bash
    export JAVAWS_BIN="${jnlpApp}/bin/javaws"
    export PATH="${pkgs.jdk8}/bin:$PATH"
    export JAVA_HOME="${pkgs.jdk8}"
    exec "$JAVAWS_BIN" "$@"
  '';
  apppkgs = with pkgs; [
    audacity
    alacritty
    freefilesync
    inkscape
    #librecad
    #qcad
    qdirstat
    google-chrome
    firefox
    kitty
    #kicad
    meld
    gpu-viewer
    gparted
    gimp3
    remmina
    veracrypt
    vlc
  ];
  officepkgs = with pkgs; [
    libreoffice-fresh
    camunda-modeler
    drawio
    yed
    obsidian
    plantuml
    texliveFull
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
    dysk
    #minicom depency lrzsz is broken
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
    yt-dlp
    yewtube
    testdisk
    exfat
    exfatprogs
    wl-clipboard
  ];
  communicationpkgs = with pkgs; [
    signal-desktop
    ferdium
    discord
    hexchat
    teamspeak3
  ];
  devpkgs = with pkgs; [
    cmake
    automake
    python3
    ghc
    nodePackages.nodejs
    git-lfs
    github-desktop
    jetbrains.phpstorm
  ];
in
{
  imports = [
    ./networking.nix
    ./games.nix
  ];

  config = lib.mkMerge [
    {
      environment.systemPackages = apppkgs ++ clipkgs ++ [ javawsWrapper ];

      programs.java.enable = true;
      programs.git = {
        enable = true;
        config.core.editor = "vim";
      };
      programs.direnv.enable = true;
      programs.obs-studio = {
        enable = true;
        enableVirtualCamera = true;
        plugins = with pkgs.obs-studio-plugins; [
          obs-backgroundremoval
        ];
      };
      programs.noisetorch.enable = true;

      services.flatpak.enable = true;
      systemd.services.flatpak-repo = {
        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        serviceConfig.Type = "oneshot";
        path = [ pkgs.flatpak ];
        script = ''
          flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        '';
      };
    }

    (lib.mkIf cfg.office {
      environment.systemPackages = officepkgs;
    })

    (lib.mkIf cfg.dev {
      environment.systemPackages = devpkgs;
      programs.vscode.enable = true;
    })

    (lib.mkIf cfg.communication {
      environment.systemPackages = communicationpkgs;
      programs.evolution.enable = true;
    })

    (lib.mkIf cfg.emacs {
      services.emacs = {
        enable = true;
        package = pkgs.emacs-gtk;
      };
    })
  ];
}
