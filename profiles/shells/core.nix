{ config, lib, pkgs, ... }:
{
  options.myConfigs.shells.core.enable = lib.mkEnableOption "the core command-line tools";

  config = lib.mkIf config.myConfigs.shells.core.enable {
    environment.systemPackages = with pkgs; [
      htop
      tree
    ];
  };
}
