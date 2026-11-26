{ config, lib, ... }: {
  options.myConfigs.core.fwupd.enable = lib.mkEnableOption "firmware updates";

  config = lib.mkIf config.myConfigs.core.fwupd.enable {
    services.fwupd.enable = true;
  };
}
