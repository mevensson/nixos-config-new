{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url = "github:numtide/devshell";
    treefmt-nix.url = "github:numtide/treefmt-nix";
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
            modules = [
              ./hosts/ryzen/configuration.nix

              ./profiles/boot/systemd-boot.nix
              ./profiles/graphical/gdm.nix
              ./profiles/graphical/gnome.nix

              ./users/matte.nix
            ];
          };
          t14g1 = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./hosts/t14g1/configuration.nix

              ./profiles/boot/systemd-boot.nix
              ./profiles/graphical/gdm.nix
              ./profiles/graphical/gnome.nix

              ./users/matte.nix
            ];
          };
        };
      };

      systems = [
        "x86_64-linux"
      ];

      perSystem = { pkgs, system, ... }: {
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
          ];
          packages = [
            pkgs.rnix-lsp
            pkgs.vscode
          ];
        };

        treefmt = {
          projectRootFile = "flake.nix";
          programs.nixpkgs-fmt.enable = true;
        };
      };
    };
}
