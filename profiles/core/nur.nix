{ nur, ... }:
{
  imports = [
    nur.modules.nixos.default
  ];

  home-manager.sharedModules = [
    nur.modules.homeManager.default
  ];
}
