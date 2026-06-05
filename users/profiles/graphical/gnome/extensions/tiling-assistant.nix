{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.tiling-assistant
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "tiling-assistant@leleat-on-github"
      ];
    };

    "org/gnome/shell/extensions/tiling-assistant" = {
      window-gap = lib.hm.gvariant.mkInt32 5;
      enable-tiling-popup = true;
      enable-advanced-experimental-features = true;

      favorite-layouts = [
        ''{"_name":"3 Equal Columns","_items":[{"rect":{"x":0,"y":0,"width":0.333,"height":1},"appId":null,"loopType":null},{"rect":{"x":0.333,"y":0,"width":0.333,"height":1},"appId":null,"loopType":null},{"rect":{"x":0.666,"y":0,"width":0.333,"height":1},"appId":null,"loopType":null}]}''
        ''{"_name":"2x16:9 Left + Right","_items":[{"rect":{"x":0,"y":0,"width":0.374,"height":0.5},"appId":null,"loopType":null},{"rect":{"x":0,"y":0.5,"width":0.374,"height":0.5},"appId":null,"loopType":null},{"rect":{"x":0.374,"y":0,"width":0.626,"height":1},"appId":null,"loopType":null}]}''
      ];

      activate-layout0 = [ "<Super>KP_1" ];
      activate-layout1 = [ "<Super>KP_2" ];
    };

    "org/gnome/desktop/wm/keybindings" = {
      move-to-workspace-left = [ "<Shift><Control><Super>Left" ];
      move-to-workspace-right = [ "<Shift><Control><Super>Right" ];
      switch-to-workspace-left = [ "<Control><Super>Left" ];
      switch-to-workspace-right = [ "<Control><Super>Right" ];
    };
  };
}
