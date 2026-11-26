{ ... }:
{
  myConfigs.core = {
    enable = true;
    disko.enable = true;
  };
  myConfigs.graphical = {
    gdm.enable = true;
    gnome.enable = true;
  };

  imports = [
    ../../profiles/boot/systemd-boot.nix
    ../../profiles/core/default.nix
    ../../profiles/graphical/gdm.nix
    ../../profiles/graphical/gnome.nix
    ../../profiles/shells/core.nix
    ../../profiles/shells/fish.nix

    ../../users/matte.nix
  ];
}
