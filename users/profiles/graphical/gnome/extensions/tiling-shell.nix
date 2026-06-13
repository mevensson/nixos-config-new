{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.tiling-shell
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "tilingshell@ferrarodomenico.com"
      ];
    };

    "org/gnome/shell/extensions/tilingshell" = {
      inner-gaps = lib.hm.gvariant.mkInt32 5;
      outer-gaps = lib.hm.gvariant.mkInt32 5;
      enable-snap-assist = true;
      show-indicator = true;
      enable-tiling-system = true;
      enable-move-keybindings = true;
      active-screen-edges = true;

      layouts-json = lib.hm.gvariant.mkString
        ''[{"id":"3 Equal Columns","tiles":[{"x":0,"y":0,"width":0.333,"height":1,"groups":[1]},{"x":0.333,"y":0,"width":0.333,"height":1,"groups":[1,2]},{"x":0.666,"y":0,"width":0.333,"height":1,"groups":[2]}]},{"id":"2x16:9 Left + Right","tiles":[{"x":0,"y":0,"width":0.374,"height":0.5,"groups":[1,2]},{"x":0,"y":0.5,"width":0.374,"height":0.5,"groups":[1,2]},{"x":0.374,"y":0,"width":0.626,"height":1,"groups":[2,3]}]}]'';
    };

    "org/gnome/desktop/wm/keybindings" = {
      move-to-workspace-left = [ "<Shift><Control><Super>Left" ];
      move-to-workspace-right = [ "<Shift><Control><Super>Right" ];
      switch-to-workspace-left = [ "<Control><Super>Left" ];
      switch-to-workspace-right = [ "<Control><Super>Right" ];
    };
  };
}
