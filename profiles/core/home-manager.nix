{ home-manager, plasma-manager, config, lib, ... }:
{
  imports = [
    home-manager.nixosModules.home-manager
  ];

  options.myConfigs.core.home-manager.enable = lib.mkEnableOption "the Home Manager integration profile";

  config = lib.mkIf config.myConfigs.core.home-manager.enable {

    home-manager.backupFileExtension = "backup";
    home-manager.useUserPackages = true;
    home-manager.sharedModules = [
      plasma-manager.homeModules.plasma-manager
      {
        nixpkgs.config.allowUnfree = true;
      }
    ];
  };
}
