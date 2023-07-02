{ agenix, ... }:
{
  imports = [ agenix.nixosModules.default ];

  age.identityPaths = [ "/var/lib/persistent/ssh_host_ed25519_key" ];
}
