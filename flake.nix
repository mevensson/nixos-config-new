{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, ... } @inputs: {
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
  }
  //
  inputs.flake-utils.lib.eachDefaultSystem (system: {
    devShells = {
      default =
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ inputs.devshell.overlays.default ];
          };
        in
        pkgs.devshell.fromTOML ./devshell.toml;
    };
  });
}
