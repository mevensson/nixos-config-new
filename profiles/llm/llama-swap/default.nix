{ pkgs, lib, ... }:

{
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
}
