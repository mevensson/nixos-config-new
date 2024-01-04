{ lib, pkgs, ... }:
{
  home = {
    file = {
      ".config/variety/variety.conf".source = ./bing.conf;
    };
  };
}
