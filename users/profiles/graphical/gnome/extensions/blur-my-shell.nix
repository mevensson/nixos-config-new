{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    gnomeExtensions.blur-my-shell
  ];

  dconf.settings = {
    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      override-background-dynamically = true;
    };
  };
}
