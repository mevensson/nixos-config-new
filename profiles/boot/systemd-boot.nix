{ ... }: {
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
}

