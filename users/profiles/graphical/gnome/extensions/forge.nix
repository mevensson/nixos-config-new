{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.forge
  ];

  dconf.settings = {
    "org/gnome/mutter/keybindings" = {
      maximize = [ ];
      move-to-monitor-down = [ ];
      move-to-monitor-left = [ ];
      move-to-monitor-right = [ ];
      move-to-monitor-up = [ ];
      move-to-workspace-left = [ "<Shift><Control><Super>Left" ];
      move-to-workspace-right = [ "<Shift><Control><Super>Right" ];
      switch-to-workspace-left = [ "<Control><Super>Left" ];
      switch-to-workspace-right = [ "<Control><Super>Right" ];
      toggle-tiled-left = [ ];
      toggle-tiled-right = [ ];
      unmaximize = [ ];
    };

    "org/gnome/shell/extensions/forge" = {
      auto-split-enabled = false;
      stacked-tiling-mode-enabled = false;
      window-gap-size = lib.hm.gvariant.mkUint32 5;
    };

    "org/gnome/shell/extensions/forge/keybindings" = {
      con-split-horizontal = [ "<Shift><Super>h" ];
      con-split-vertical = [ "<Shift><Super>v" ];
      con-split-layout-toggle = [ "<Shift><Super>g" ];
      con-stacked-layout-toggle = [ "<Shift><Super>s" ];
      con-tabbed-layout-toggle = [ "<Shift><Super>t" ];
      window-focus-down = [ "<Super>Down" ];
      window-focus-left = [ "<Super>Left" ];
      window-focus-right = [ "<Super>Right" ];
      window-focus-up = [ "<Super>Up" ];
      window-move-down = [ "<Shift><Super>Down" ];
      window-move-left = [ "<Shift><Super>Left" ];
      window-move-right = [ "<Shift><Super>Right" ];
      window-move-up = [ "<Shift><Super>Up" ];
      window-resize-bottom-decrease = [ "<Shift><Alt><Super>Down" ];
      window-resize-bottom-increase = [ "<Alt><Super>Down" ];
      window-resize-left-decrease = [ "<Shift><Alt><Super>Left" ];
      window-resize-left-increase = [ "<Alt><Super>Left" ];
      window-resize-right-decrease = [ "<Shift><Alt><Super>Right" ];
      window-resize-right-increase = [ "<Alt><Super>Right" ];
      window-resize-top-decrease = [ "<Shift><Alt><Super>Up" ];
      window-resize-top-increase = [ "<Alt><Super>Up" ];
      window-toggle-alway-float = [ "<Shift><Super>f" ];
      window-toggle-float = [ "<Super>f" ];
    };
  };
}
