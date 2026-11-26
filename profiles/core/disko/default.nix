{ disko, config, lib, ... }:
{
  imports = [
    disko.nixosModules.disko
  ];

  options.myConfigs.core.disko.enable = lib.mkEnableOption "Disko-generated system configuration";

  # Keep the upstream build interfaces available without applying device config
  # merely because the module was discovered.
  config.disko.enableConfig = lib.mkDefault config.myConfigs.core.disko.enable;
}
