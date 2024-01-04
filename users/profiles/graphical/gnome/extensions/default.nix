{ lib, pkgs, ... }:

{
  imports = [
    ./forge.nix
    ./tray-icons-reloaded.nix
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "forge@jmmaranan.com"
        "trayIconsReloaded@selfmade.pl"
      ];
    };
  };
}
