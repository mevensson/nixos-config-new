{ lib, pkgs, ... }:

{
  imports = [
    ./appindicator.nix
    ./blur-my-shell.nix
    ./espresso.nix
    ./extension-list.nix
    ./vitals.nix
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
    };
  };
}
