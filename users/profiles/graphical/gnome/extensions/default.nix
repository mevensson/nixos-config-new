{ lib, pkgs, ... }:

{
  imports = [
    ./appindicator.nix
    ./blur-my-shell.nix
    ./espresso.nix
    ./extension-list.nix
    ./forge.nix
    ./gsconnect.nix
    ./vitals.nix
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "blur-my-shell@aunetx"
        "espresso@coadmunkee.github.com"
        "extension-list@tu.berry"
        "forge@jmmaranan.com"
        "gsconnect@andyholmes.github.io"
        "Vitals@CoreCoding.com"
      ];
    };
  };
}
