{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.espresso
  ];

  dconf.settings = {
    "org/gnome/shell/extensions/espresso" = {
      enable-charging = true;
      enable-docked = true;
    };
  };
}
