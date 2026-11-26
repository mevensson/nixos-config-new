{ config, lib, pkgs, ... }: {
  options.myConfigs.graphical.gsconnect.enable = lib.mkEnableOption "GSConnect for GNOME";

  config = lib.mkIf config.myConfigs.graphical.gsconnect.enable {
    myConfigs.graphical.gnome.enable = lib.mkDefault true;
    programs.kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };
}
