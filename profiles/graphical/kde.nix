{ config, lib, pkgs, ... }: {
  options.myConfigs.graphical.kde.enable = lib.mkEnableOption "the KDE Plasma desktop profile";

  config = lib.mkIf config.myConfigs.graphical.kde.enable {
    environment.systemPackages = with pkgs; [
    ];

    programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.ksshaskpass.out}/bin/ksshaskpass";

    services = {
      desktopManager = {
        plasma6 = {
          enable = true;
        };
      };
    };
  };
}
