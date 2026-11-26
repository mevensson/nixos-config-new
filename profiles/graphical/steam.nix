{ config, lib, ... }: {
  options.myConfigs.graphical.steam.enable = lib.mkEnableOption "Steam with 32-bit graphics support";

  config = lib.mkIf config.myConfigs.graphical.steam.enable {
    hardware.graphics.enable32Bit = true;

    programs.steam = {
      enable = true;
    };
  };
}
