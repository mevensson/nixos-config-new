{ config, pkgs, lib, ... }:

{
  imports = import ../../../lib/discover-modules.nix ./.;

  options.myConfigs.llm.llama-swap.enable = lib.mkEnableOption "the local llama-swap service";

  config = lib.mkIf config.myConfigs.llm.llama-swap.enable {
    users.users.llama-swap = {
      isSystemUser = true;
      group = "llama-swap";
    };
    users.groups.llama-swap = { };

    environment.systemPackages = [
      (pkgs.llama-cpp.override { vulkanSupport = true; })
      pkgs.llama-swap
    ];

    services.llama-swap = {
      enable = true;
      settings = {
        healthCheckTimeout = 300;
        logLevel = "info";
        startPort = 10001;
        sendLoadingState = true;
      };
    };

    systemd.services.llama-swap = {
      serviceConfig = {
        User = lib.mkForce "llama-swap";
        DynamicUser = lib.mkForce false;
        StateDirectory = "llama-swap";
      };
    };
  };
}
