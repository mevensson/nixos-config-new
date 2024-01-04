{ lib, pkgs, ... }:

{
  imports = [
    ./espresso.nix
    ./forge.nix
    ./tray-icons-reloaded.nix
    ./vitals.nix
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "espresso@coadmunkee.github.com"
        "forge@jmmaranan.com"
        "trayIconsReloaded@selfmade.pl"
        "Vitals@CoreCoding.com"
      ];
    };
  };
}
