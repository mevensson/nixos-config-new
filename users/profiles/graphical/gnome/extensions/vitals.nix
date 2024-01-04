{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.vitals
  ];

  dconf.settings = {
    "org/gnome/shell/extensions/vitals" = {
      fixed-widths = false;
      hot-sensors = [
        "_processor_usage_"
        "_processor_frequency_"
        "_memory_allocated_"
        "_storage_free_"
        "__network-rx_max__"
      ];
      menu-centered = true;
      show-battery = true;
    };
  };
}
