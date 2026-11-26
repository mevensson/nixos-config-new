{ agenix, config, lib, ... }:
{
  imports = [ agenix.nixosModules.default ];

  options.myConfigs.core.agenix.enable = lib.mkEnableOption "the agenix profile";

  config = lib.mkMerge [
    # Upstream otherwise enables itself whenever secrets are defined.
    { age.enable = lib.mkDefault config.myConfigs.core.agenix.enable; }
    (lib.mkIf config.myConfigs.core.agenix.enable {
      age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    })
  ];
}
