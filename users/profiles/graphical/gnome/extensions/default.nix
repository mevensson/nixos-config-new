{ lib, pkgs, ... }:

{
  imports = [
    ./espresso.nix
    ./extension-list.nix
    ./forge.nix
    ./gsconnect.nix
    ./tray-icons-reloaded.nix
    ./vitals.nix
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "espresso@coadmunkee.github.com"
        "extension-list@tu.berry"
        "forge@jmmaranan.com"
        "gsconnect@andyholmes.github.io"
        "trayIconsReloaded@selfmade.pl"
        "Vitals@CoreCoding.com"
      ];
    };
  };
}
