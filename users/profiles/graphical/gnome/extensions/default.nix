{ lib, pkgs, ... }:

{
  imports = [
    ./forge.nix
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "forge@jmmaranan.com"
      ];
    };
  };
}
