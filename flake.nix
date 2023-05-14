{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, ... } @inputs: {
    nixosConfigurations = {
      ryzen = {
      };
      t14g1 = {
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
            overlays = [ inputs.devshell.overlays.default ];
          };
        in
        pkgs.devshell.fromTOML ./devshell.toml;
    };
  });
}
