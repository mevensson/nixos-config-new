{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.gsconnect
  ];
}
