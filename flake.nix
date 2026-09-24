{
  description = "System Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      lib = nixpkgs.lib;

      # ── Gemeinsame Module für alle Desktop-Hosts ──
      commonModules = [
        ./modules/options.nix
        ./configuration.nix
        ./modules/user/colaholiker
        ./modules/software/fonts
        ./modules/software/localisation
        ./modules/software/applications
        ./modules/software/virtualisation
        ./modules/software/displaymanager
        ./modules/software/deskflow
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-backup";
          home-manager.users.colaholiker = import ./modules/user/colaholiker/home.nix;
        }
      ];

      # ── Helper: Desktop-Host erzeugen ──
      # stateVersion = NixOS-Version bei der Installation des Hosts, niemals nachträglich ändern
      mkHost = {
        hostModule,
        stateVersion,
        features,
        extraModules ? [],
      }:
      lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { system.stateVersion = stateVersion;
            local.features = features;
          }
          hostModule
        ] ++ extraModules ++ commonModules;
      };

    in {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;

      nixosConfigurations = {

        heindl-pollux = mkHost {
          hostModule = ./modules/host/heindl-pollux;
          stateVersion = "25.11";
          features = {
            wayland = true;
            plasma6 = true;
            networking = true;
            games = false;
            office = true;
            dev = true;
            communication = true;
            emacs = true;
            deskflow = true;
            docker = true;
            winboat = false;
            virtualbox = false;
            libvirt = false;
          };
        };


      };
    };
}