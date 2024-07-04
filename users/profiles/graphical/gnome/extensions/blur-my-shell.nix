{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    gnomeExtensions.blur-my-shell
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "blur-my-shell@aunetx"
      ];
    };

    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      override-background-dynamically = true;
    };
  };
}
