{ nix-index-database, ... }:
{
  imports = [
    nix-index-database.nixosModules.nix-index
  ];

  programs.command-not-found.enable = false;
  programs.nix-index-database.comma.enable = true;
}
