{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.vitals
  ];

  dconf.settings = {
    "org/gnome/shell/extensions/vitals" = {
      hot-sensors = [
        "_processor_usage_"
        "_processor_frequency_"
        "_system_load_15m_"
        "_memory_usage_"
        "_memory_allocated_"
        "_storage_free_"
        "__network-rx_max__"
      ];
      show-battery = true;
    };
  };
}
