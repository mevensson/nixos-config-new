{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gnome-tweaks

    firmware-updater
    gnome-firmware

    celluloid
  ];

  services = {
    # Enable flatpak for gnome-software
    flatpak = {
      enable = true;
    };

    # Enable GNOME browser connector service
    gnome = {
      gnome-browser-connector.enable = true;
    };

    xserver = {
      desktopManager.gnome = {
        enable = true;
      };
    };
  };
}
