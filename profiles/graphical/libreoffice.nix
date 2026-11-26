{ config, lib, pkgs, ... }: {
  options.myConfigs.graphical.libreoffice.enable = lib.mkEnableOption "LibreOffice";

  config = lib.mkIf config.myConfigs.graphical.libreoffice.enable {
    environment.systemPackages = with pkgs; [
      libreoffice
    ];
  };
}
