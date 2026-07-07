{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    mission-center

    firmware-updater
    gnome-firmware

    celluloid
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    pkgs."nerd-fonts".jetbrains-mono
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
