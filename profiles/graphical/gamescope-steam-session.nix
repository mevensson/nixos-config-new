{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    pkgs.mangohud
  ];

  hardware = {
    xone.enable = true;
    xpadneo.enable = true;
  };

  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    steam = {
      gamescopeSession = {
        enable = true;
        args = [
          "--rt"
          "--mangoapp"
        ]
        # Workaround to pass arguments to steam
        ++ [
          "--"
          "steam"
          "-tenfoot"
          "-pipewire-dmabuf"
          "-steamos3"
          "-steampal"
          "-steamdeck"
          "#"
        ];
        env = {
          # From https://github.com/ChimeraOS/gamescope-session-steam/blob/main/usr/share/gamescope-session-plus/sessions.d/steam
          # Show VRR controls in Steam
          STEAM_GAMESCOPE_VRR_SUPPORTED = "1";
          # Enable Mangoapp
          STEAM_MANGOAPP_PRESETS_SUPPORTED = "1";
          STEAM_USE_MANGOAPP = "1";
          # We no longer need to set GAMESCOPE_EXTERNAL_OVERLAY from steam, mangoapp now does it itself
          STEAM_DISABLE_MANGOAPP_ATOM_WORKAROUND = "1";
          # Enable horizontal mangoapp bar
          STEAM_MANGOAPP_HORIZONTAL_SUPPORTED = "1";
          # Support for gamescope tearing with GAMESCOPE_ALLOW_TEARING atom
          STEAM_GAMESCOPE_HAS_TEARING_SUPPORT = "1";
          # Enable tearing controls in steam
          STEAM_GAMESCOPE_TEARING_SUPPORTED = "1";
          STEAM_GAMESCOPE_HDR_SUPPORTED = "1";
          # Enable volume key management via steam for this session
          STEAM_ENABLE_VOLUME_HANDLER = "1";
          # We have the Mesa integration for the fifo-based dynamic fps-limiter
          STEAM_GAMESCOPE_DYNAMIC_FPSLIMITER = "1";
          # Scaling support
          STEAM_GAMESCOPE_FANCY_SCALING_SUPPORT = "1";
          # Color management support
          STEAM_GAMESCOPE_COLOR_MANAGED = "1";
          STEAM_GAMESCOPE_VIRTUAL_WHITE = "1";
          STEAM_USE_DYNAMIC_VRS = "1";
          # Have SteamRT's xdg-open send http:// and https:// URLs to Steam
          SRT_URLOPEN_PREFER_STEAM = "1";
          # Enable support for xwayland isolation per-game in Steam
          STEAM_MULTIPLE_XWAYLANDS = "1";
          # When set to 1, a toggle will show up in the steamui to control whether dynamic refresh rate is applied to the steamui
          STEAM_GAMESCOPE_DYNAMIC_REFRESH_IN_STEAM_SUPPORTED = "0";
          # Set input method modules for Qt/GTK that will show the Steam keyboard
          QT_IM_MODULE = "steam";
          GTK_IM_MODULE = "Steam";
        };
      };
    };
  };
}
