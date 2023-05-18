{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
  ];

  boot.plymouth.enable = true;

  services = {
    xserver = {
      #enable = true;
      #layout = "se";

      #libinput = {
      #  enable = true;
      #};

      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
  };
}

