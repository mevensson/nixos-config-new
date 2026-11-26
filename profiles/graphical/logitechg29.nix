{ config, lib, pkgs, ... }: {
  options.myConfigs.graphical.logitechg29 = {
    enable = lib.mkEnableOption "Logitech G29 support with Oversteer";
    new-lg4ff.enable = lib.mkEnableOption "the alternative Logitech force-feedback driver";
  };

  config = lib.mkIf config.myConfigs.graphical.logitechg29.enable {
    environment.systemPackages = with pkgs; [
      oversteer
    ];

    hardware.new-lg4ff.enable = lib.mkIf config.myConfigs.graphical.logitechg29.new-lg4ff.enable true;

    services.udev.packages = with pkgs; [
      oversteer
    ];
  };
}
