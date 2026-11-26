{ config, lib, ... }:
{
  imports = import ../../lib/discover-modules.nix ./.;

  options.myConfigs.core.enable = lib.mkEnableOption "the curated core profile bundle";

  config = lib.mkIf config.myConfigs.core.enable {
    myConfigs.core = lib.genAttrs [
      "agenix"
      "auto-gc"
      "auto-optimize"
      "cachix"
      "fwupd"
      "home-manager"
      "immutable-users"
      "kernel"
      "locales"
      "nix-index"
      "nur"
      "nixos"
      "printing"
      "ssh"
    ]
      (_: { enable = lib.mkDefault true; });
  };
}
