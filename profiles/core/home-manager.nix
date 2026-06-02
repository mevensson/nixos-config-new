{ home-manager, plasma-manager, ... }:
{
  imports = [
    home-manager.nixosModules.home-manager
  ];

  home-manager.backupFileExtension = "backup";
  home-manager.useUserPackages = true;
  home-manager.sharedModules = [
    plasma-manager.homeModules.plasma-manager
    {
      nixpkgs.config.allowUnfree = true;
    }
  ];
}
