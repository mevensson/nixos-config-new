{ pkgs, ... }: {
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
}

