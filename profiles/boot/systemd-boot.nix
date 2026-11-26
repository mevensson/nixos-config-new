{ config, lib, ... }: {
  options.myConfigs.boot.systemd-boot.enable = lib.mkEnableOption "the systemd-boot profile";

  config = lib.mkIf config.myConfigs.boot.systemd-boot.enable {
    boot = {
      kernelParams = [
        "systemd.setenv=SYSTEMD_SULOGIN_FORCE=1"
      ];
      loader = {
        efi = {
          canTouchEfiVariables = false;
        };
        systemd-boot = {
          enable = true;
          configurationLimit = 10;
        };
      };
    };
  };
}
