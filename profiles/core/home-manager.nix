{ home-manager, plasma-manager, ... }:
{
  imports = [
    home-manager.nixosModules.home-manager
  ];

  home-manager.backupFileExtension = "backup";
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.sharedModules = [
    plasma-manager.homeManagerModules.plasma-manager
  ];
}
