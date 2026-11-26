{ config, lib, ... }: {
  options.myConfigs.core.auto-optimize.enable = lib.mkEnableOption "automatic Nix store optimisation";

  config = lib.mkIf config.myConfigs.core.auto-optimize.enable {
    nix.settings = {
      auto-optimise-store = true;
    };
    nix.optimise = {
      automatic = true;
      dates = [ "03:45" ];
    };
  };
}
