{ config, lib, pkgs, ... }: {
  options.myConfigs.graphical.discord.enable = lib.mkEnableOption "Discord";

  config = lib.mkIf config.myConfigs.graphical.discord.enable {
    environment.systemPackages = with pkgs; [
      discord
    ];
  };
}
