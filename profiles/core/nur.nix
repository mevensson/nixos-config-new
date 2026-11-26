{ nur, config, lib, ... }:
{
  options.myConfigs.core.nur.enable = lib.mkEnableOption "NUR system and Home Manager overlays";

  config = lib.mkIf config.myConfigs.core.nur.enable {
    myConfigs.core.home-manager.enable = lib.mkDefault true;

    # The upstream NixOS module installs this overlay unconditionally.
    nixpkgs.overlays = [ nur.overlays.default ];

    home-manager.sharedModules = [
      nur.modules.homeManager.default
    ];
  };
}
