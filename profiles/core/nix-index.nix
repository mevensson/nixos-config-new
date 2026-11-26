{ nix-index-database, config, lib, ... }:
{
  imports = [
    nix-index-database.nixosModules.nix-index
  ];

  options.myConfigs.core.nix-index.enable = lib.mkEnableOption "nix-index with the shared database and comma";

  config = lib.mkMerge [
    # Upstream defaults this to true even when our profile is disabled.
    { programs.nix-index-database.enable = lib.mkDefault config.myConfigs.core.nix-index.enable; }
    (lib.mkIf config.myConfigs.core.nix-index.enable {
      programs.command-not-found.enable = false;
      programs.nix-index-database.comma.enable = true;
    })
  ];
}
