{ config, lib, ... }:

{
  options.myConfigs.core.cachix-deploy.enable = lib.mkEnableOption "the Cachix deployment agent";

  config = lib.mkIf config.myConfigs.core.cachix-deploy.enable {
    myConfigs.core.agenix.enable = lib.mkDefault true;

    services.cachix-agent = {
      enable = true;
      credentialsFile = config.age.secrets.cachix-deploy-agent.path;
    };

    age.secrets.cachix-deploy-agent.file = ../../secrets/${config.networking.hostName}-cachix-deploy-agent.age;
  };
}
