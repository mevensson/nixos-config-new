{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.tray-icons-reloaded
  ];
}
