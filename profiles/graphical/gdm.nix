{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
  ];

  boot.plymouth.enable = false;

  services = {
    libinput = {
      enable = true;
    };

    xserver = {
      enable = true;

      xkb = {
        layout = "se";
      };

      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
  };
}

