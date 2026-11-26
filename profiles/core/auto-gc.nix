{ config, lib, ... }: {
  options.myConfigs.core.auto-gc.enable = lib.mkEnableOption "automatic Nix garbage collection";

  config = lib.mkIf config.myConfigs.core.auto-gc.enable {
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 60d";
    };
  };
}
