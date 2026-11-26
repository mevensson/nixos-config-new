{ config, lib, pkgs, ... }: {
  options.myConfigs.graphical.gdm.enable = lib.mkEnableOption "the GDM display manager profile";

  config = lib.mkIf config.myConfigs.graphical.gdm.enable {
    environment.systemPackages = with pkgs; [
    ];

    boot.plymouth.enable = false;

    services = {
      libinput = {
        enable = true;
      };

      displayManager.gdm = {
        enable = true;
      };

      xserver = {
        enable = true;

        xkb = {
          layout = "se";
        };
      };
    };
  };
}
