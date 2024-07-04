{ lib, pkgs, ... }:

{
  imports = [
  ];

  programs.plasma = {
    enable = true;
    overrideConfig = true;

    workspace = {
      theme = "breeze-dark";
      wallpaperPictureOfTheDay = {
        provider = "bing";
      };
    };

    panels = [
      {
        location = "top";
        height = 32;
        hiding = "none";
        floating = true;


        widgets = [
          "org.kde.plasma.kickerdash"
          "org.kde.plasma.pager"
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.digitalclock"
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.systemmonitor.cpu"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.lock_logout"
        ];
      }
    ];

    configFile = {
      "kcminputrc" = {
        "Libinput.2.10.TPPS/2 Elan TrackPoint" = {
          "NaturalScroll" = true;
        };
      };
    };
  };
}
