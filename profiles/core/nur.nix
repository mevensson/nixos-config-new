{ nur, ... }:
{
  imports = [
    nur.nixosModules.nur
  ];

  home-manager.sharedModules = [
    nur.hmModules.nur
  ];
}
