{ config, lib, ... }: {
  options.myConfigs.core.ssh.enable = lib.mkEnableOption "the SSH server";

  config = lib.mkIf config.myConfigs.core.ssh.enable {
    services.openssh = {
      enable = true;
    };
  };
}
