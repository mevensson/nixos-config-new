{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.extension-list
  ];
}
