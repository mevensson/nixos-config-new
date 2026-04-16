{ nixos-facter-modules, ... }:
{
  imports = [
    nixos-facter-modules.nixosModules.facter
  ];
}
