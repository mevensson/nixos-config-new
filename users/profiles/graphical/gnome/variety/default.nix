{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      variety
    ];

    file = {
      ".config/autostart/variety.desktop".source = (pkgs.variety + "/share/applications/variety.desktop");
    };
  };
}
