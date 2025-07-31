{
  description = "My NixOS config";

  nixConfig = {
    extra-substituters = [
      "https://mevensson-nixos-config.cachix.org"
      "https://nyx.chaotic.cx/"
    ];
    extra-trusted-public-keys = [
      "mevensson-nixos-config.cachix.org-1:nTyMdA8pqMkgk0Amny05+p3ujTE90BTilJPMwceHSEQ="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
    ];
    allow-import-from-derivation = true;
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    cachix-deploy = {
      url = "github:cachix/cachix-deploy-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.disko.follows = "disko";
      inputs.home-manager.follows = "home-manager";
    };
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ... } @inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {

      imports = [
        inputs.devshell.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      flake = {
        nixosConfigurations = {
          ryzen = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = inputs;
            modules = [
              ./hosts/ryzen/configuration.nix

              ./profiles/boot/systemd-boot.nix
              ./profiles/core/default.nix
              ./profiles/core/cachix-deploy.nix
              ./profiles/graphical/discord.nix
              ./profiles/graphical/gamescope-steam-session.nix
              ./profiles/graphical/gdm.nix
              ./profiles/graphical/gnome.nix
              ./profiles/graphical/libreoffice.nix
              ./profiles/graphical/logitechg29.nix
              ./profiles/graphical/spotify.nix
              ./profiles/graphical/steam.nix
              ./profiles/remotefs/sshfs/ds920.nix
              ./profiles/shells/core.nix
              ./profiles/shells/fish.nix
              ./profiles/sound/pipewire.nix

              ./users/matte.nix
              ./users/test.nix
            ];
          };
          t14g1 = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = inputs;
            modules = [
              ./hosts/t14g1/configuration.nix

              ./profiles/boot/systemd-boot.nix
              ./profiles/core/default.nix
              ./profiles/core/cachix-deploy.nix
              ./profiles/graphical/discord.nix
              ./profiles/graphical/gamescope-steam-session.nix
              ./profiles/graphical/gdm.nix
              ./profiles/graphical/gnome.nix
              ./profiles/graphical/libreoffice.nix
              ./profiles/graphical/spotify.nix
              ./profiles/graphical/steam.nix
              ./profiles/remotefs/sshfs/ds920.nix
              ./profiles/shells/core.nix
              ./profiles/shells/fish.nix
              ./profiles/sound/pipewire.nix

              ./users/matte.nix
            ];
          };
          game = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = inputs;
            modules = [
              ./hosts/game/configuration.nix

              ./profiles/boot/systemd-boot.nix
              ./profiles/core/default.nix
              ./profiles/core/cachix-deploy.nix
              ./profiles/graphical/gnome.nix
              ./profiles/remotefs/sshfs/ds920.nix
              ./profiles/shells/core.nix
              ./profiles/shells/fish.nix
              ./profiles/sound/pipewire.nix

              ./users/matte.nix
            ];
          };
          live-installer = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = inputs;
            modules = [
              ./hosts/live-installer/configuration.nix
            ];
          };
        };
      };

      systems = [
        "x86_64-linux"
      ];

      perSystem = { config, pkgs, system, ... }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        packages =
          let
            cachix-deploy-lib = inputs.cachix-deploy.lib pkgs;
            getDerivation = system: inputs.self.nixosConfigurations.${system}.config.system.build.toplevel;
          in
          {
            cachix-deploy-ryzen =
              cachix-deploy-lib.spec {
                agents = {
                  ryzen = getDerivation "ryzen";
                };
              };
            cachix-deploy-t14g1 =
              cachix-deploy-lib.spec {
                agents = {
                  t14g1 = getDerivation "t14g1";
                };
              };
            cachix-deploy-game =
              cachix-deploy-lib.spec {
                agents = {
                  game = getDerivation "game";
                };
              };
          };

        devshells.default = {
          commands = [
            {
              name = "fmt";
              help = "Format all files.";
              command = "nix fmt";
            }
            {
              name = "check";
              help = "Check the flake for errors.";
              command = "nix flake check";
            }
            {
              package = "gh";
            }
            {
              package = "cachix";
            }
          ];
          packages = [
            pkgs.vscode
            config.treefmt.build.wrapper
            inputs.agenix.packages.${system}.default
            pkgs.nixpkgs-fmt
          ];
        };

        treefmt = {
          projectRootFile = "flake.nix";
          programs.nixpkgs-fmt.enable = true;
        };
      };
    };
}
