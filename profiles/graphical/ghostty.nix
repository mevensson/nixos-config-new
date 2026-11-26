{ config, lib, pkgs, ... }: {
  options.myConfigs.graphical.ghostty.enable = lib.mkEnableOption "the Ghostty terminal";

  config = lib.mkIf config.myConfigs.graphical.ghostty.enable {
    environment.systemPackages = with pkgs; [
      ghostty
    ];
  };
}
