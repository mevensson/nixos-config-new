{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.appindicator
  ];
}
