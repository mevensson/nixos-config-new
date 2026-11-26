{ config, lib, pkgs, ... }: {
  options.myConfigs.graphical.spotify.enable = lib.mkEnableOption "Spotify";

  config = lib.mkIf config.myConfigs.graphical.spotify.enable {
    environment.systemPackages = with pkgs; [
      spotify
    ];
  };
}
