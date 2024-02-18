{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
  ];

  boot.plymouth.enable = false;

  services = {
    xserver = {
      enable = true;

      xkb = {
        layout = "se";
      };

      libinput = {
        enable = true;
      };

      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
  };
}

