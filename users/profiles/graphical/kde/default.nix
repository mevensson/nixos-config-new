{ lib, pkgs, ... }:

{
  imports = [
  ];

  programs.plasma = {
    enable = true;
    overrideConfig = true;

    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
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
          {
            name = "org.kde.plasma.kickerdash";
            config = {
              General.icon = "nix-snowflake-white";
            };
          }
          {
            name = "org.kde.plasma.pager";
            config = {
              General.displayedText = "Number";
            };
          }
          "org.kde.plasma.panelspacer"
          {
            digitalClock = {
              date.format = "isoDate";
              time.format = "24h";
            };
          }
          "org.kde.plasma.panelspacer"
          {
            systemMonitor = {
              title = "Memory Usage";
              displayStyle = "org.kde.ksysguard.linechart";
              sensors = [
                {
                  name = "memory/physical/usedPercent";
                  color = "166,227,161"; # Green
                  label = "Memory Usage";
                }
              ];
              totalSensors = [
                "memory/physical/usedPercent"
              ];
              textOnlySensors = [
                "memory/physical/used"
                "memory/physical/total"
              ];
            };
          }
          {
            systemMonitor = {
              title = "CPU Usage";
              displayStyle = "org.kde.ksysguard.linechart";
              sensors = [
                {
                  name = "cpu/all/usage";
                  color = "250,179,135"; # Peach
                  label = "CPU Usage";
                }
              ];
              totalSensors = [
                "cpu/all/usage"
              ];
              textOnlySensors = [
                "cpu/all/averageTemperature"
                "cpu/all/averageFrequency"
              ];
            };
          }
          {
            systemTray = {
              icons = {
                scaleToFit = true;
                spacing = "small";
              };
              items = {
                shown = [ "org.kde.plasma.battery" ];
                hidden = [ ];
                configs = {
                  battery.showPercentage = true;
                };
              };
            };
          }
          {
            name = "org.kde.plasma.lock_logout";
            config = {
              General = {
                show_lockScreen = "false";
                show_requestLogout = "true";
                show_requestShutDown = "false";
              };
            };
          }
        ];
      }
    ];

    configFile = {
      kcminputrc = {
        # Doesn't work as the / in TPPS/2 creates a group
        "Libinput/2/10/TPPS\/2 Elan TrackPoint".NaturalScroll = true;
      };
      kscreenlockerrc = {
        Greeter.WallpaperPlugin = "org.kde.potd";
        "Greeter/Wallpaper/org.kde.potd/General" = {
          Provider = "bing";
        };
      };
    };
  };
}
