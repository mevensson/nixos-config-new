{ config, lib, pkgs, ... }:
{
  options.myConfigs.shells.fish.enable = lib.mkEnableOption "the Fish shell";

  config = lib.mkIf config.myConfigs.shells.fish.enable {
    environment.shells = [ pkgs.fish ];

    programs.fish.enable = true;
  };
}
