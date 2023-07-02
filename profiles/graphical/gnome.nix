{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
  ];

  services = {
    xserver = {
      desktopManager.gnome = {
        enable = true;
      };
    };
  };
}
