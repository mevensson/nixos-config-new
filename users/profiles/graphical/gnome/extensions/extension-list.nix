{ lib, pkgs, ... }:

let
  extension-list' = pkgs.stdenv.mkDerivation {
    pname = "gnome-shell-extension-extension-list";
    version = "50.2";

    src = pkgs.fetchFromGitHub {
      owner = "tuberry";
      repo = "extension-list";
      rev = "50.2";
      hash = "sha256-1kZVOr8MbjN9ZYNOejH6H3LBgHF3B8W4iXPVqR6HXbQ=";
    };

    nativeBuildInputs = with pkgs; [ meson ninja pkg-config sassc ];
    buildInputs = with pkgs; [ glib ];

    mesonFlags = [ "-Dtarget=system" ];
  };
in

{
  home.packages = [ extension-list' ];

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "extension-list@tu.berry"
      ];
    };
  };
}