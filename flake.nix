{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    devshell = {
      url = "github:numtide/devshell";
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
              ./profiles/core/agenix.nix
              ./profiles/core/auto-upgrade.nix
              ./profiles/core/fwupd.nix
              ./profiles/core/home-manager.nix
              ./profiles/core/kernel.nix
              ./profiles/core/locales.nix
              ./profiles/core/nix-index.nix
              ./profiles/core/nixos.nix
              ./profiles/core/printing.nix
              ./profiles/core/ssh.nix
              ./profiles/graphical/discord.nix
              ./profiles/graphical/gdm.nix
              ./profiles/graphical/gnome.nix
              ./profiles/graphical/kde.nix
              ./profiles/graphical/libreoffice.nix
              ./profiles/graphical/spotify.nix
              ./profiles/graphical/steam.nix
              ./profiles/shells/core.nix
              ./profiles/shells/fish.nix

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
              ./profiles/core/agenix.nix
              ./profiles/core/auto-upgrade.nix
              ./profiles/core/fwupd.nix
              ./profiles/core/home-manager.nix
              ./profiles/core/kernel.nix
              ./profiles/core/locales.nix
              ./profiles/core/nix-index.nix
              ./profiles/core/nixos.nix
              ./profiles/core/printing.nix
              ./profiles/core/ssh.nix
              ./profiles/graphical/discord.nix
              ./profiles/graphical/gdm.nix
              ./profiles/graphical/gnome.nix
              ./profiles/graphical/libreoffice.nix
              ./profiles/graphical/kde.nix
              ./profiles/graphical/spotify.nix
              ./profiles/graphical/steam.nix
              ./profiles/shells/core.nix
              ./profiles/shells/fish.nix

              ./users/matte.nix
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
          ];
          packages = [
            pkgs.vscode
            config.treefmt.build.wrapper
            inputs.agenix.packages.${system}.default
          ];
        };

        treefmt = {
          projectRootFile = "flake.nix";
          programs.nixpkgs-fmt.enable = true;
        };
      };
    };
}
