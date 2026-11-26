{ config, lib, ... }: {
  options.myConfigs.core.nixos.enable = lib.mkEnableOption "Nix flakes and unfree packages";

  config = lib.mkIf config.myConfigs.core.nixos.enable {
    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
      };
    };

    nixpkgs.config.allowUnfree = true;
  };
}
