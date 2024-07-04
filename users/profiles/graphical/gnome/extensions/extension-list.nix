{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.extension-list
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "extension-list@tu.berry"
      ];
    };
  };
}
