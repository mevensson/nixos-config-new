{ config, lib, ... }: {
  options.myConfigs.core.immutable-users.enable = lib.mkEnableOption "declarative immutable users";

  config = lib.mkIf config.myConfigs.core.immutable-users.enable {
    users = {
      mutableUsers = false;
    };
  };
}
