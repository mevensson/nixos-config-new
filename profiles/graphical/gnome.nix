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

    desktopManager.gnome = {
      enable = true;
    };
  };
}
