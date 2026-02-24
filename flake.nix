{
  description = "System Configuration Flake";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://numtide.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
    ];
    trusted-users = [ "root" "colaholiker" ];
  };
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, lanzaboote, ... }:
    let
      lib = nixpkgs.lib;

      # ── Gemeinsame Module für alle Desktop-Hosts ──
      commonModules = [
        ./modules/options.nix
        ./modules/user/colaholiker
        ./modules/software/fonts
        ./modules/software/localisation
        ./modules/software/applications
        ./modules/software/virtualisation
        ./modules/software/displaymanager
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.muhackel = import ./modules/user/colaholiker/home.nix;
        }
      ];

      # ── Helper: Desktop-Host erzeugen ──
      mkHost = {
        hostModule,
        stateVersion ? "26.05",
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
      nixosConfigurations = {

        heindl-pollux = mkHost {
          hostModule = ./modules/host/heindl-pollux;
          features = {
            wayland = true;
            plasma6 = true;
            networking = true;
            games = false;
            docker = true;
            winboat = false;
            virtualbox = false;
            libvirt = false;
          };
        };


      };
    };
}