{ lib, pkgs, ... }:

{
  imports = [
    ./extensions/default.nix
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    "/org/gnome/desktop/interface" = {
      cursor-theme = "Adwaita";
      icon-theme = "Adwaita";
      gtk-theme = "Adwaita";

      font-name = "Cantarell 10";
      document-font-name = "Cantarell 10";
      monospace-font-name = "DejaVu Sans Mono 10";

      font-antialiasing = "rgba";
      font-hinting = "full";

      text-scaling-factor = "1.0";
    };

    "/org/gnome/desktop/sound" = {
      theme-name = "freedesktop";
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      experimental-features = [
        "scale-monitor-framebuffer"
        "variable-refresh-rate"
      ];
    };

    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Console.desktop"
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "steam.desktop"
        "spotify.desktop"
      ];
    };
  };
}
