{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks

    firmware-updater
    gnome-firmware

    celluloid
  ];

  services = {
    # Enable flatpak for gnome-software
    flatpak = {
      enable = true;
    };
    xserver = {
      desktopManager.gnome = {
        enable = true;
      };
    };
  };
}
