{...}: {
  boot = {
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

