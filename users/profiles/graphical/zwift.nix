{ config, lib, osConfig, pkgs, ... }:
let
  username = "mattias@evensson.eu";
  podman = lib.getExe osConfig.virtualisation.podman.package;
in
{
  config = lib.mkIf (osConfig.programs.zwift.enable or false) {
    # Upstream sources the rider config before looking up the Podman secret.
    xdg.configFile."zwift/${config.home.username}-config".text = ''
      ZWIFT_USERNAME=${lib.escapeShellArg username}
      # Strip editor-added trailing newlines without exposing the password in argv.
      if ! ${pkgs.gnused}/bin/sed -z 's/\n*$//' ${lib.escapeShellArg osConfig.age.secrets.zwift_password.path} |
        ${podman} secret create --replace \
          ${lib.escapeShellArg "zwift-password-${username}"} - > /dev/null; then
        printf '%s\n' 'Failed to load the agenix Zwift password into Podman.' >&2
        exit 1
      fi

      # Keep image updates separate from upstream's imperative launcher updater.
      if [[ ''${DRYRUN:-0} != 1 ]]; then
        if ! ${podman} pull "''${IMAGE:-docker.io/netbrain/zwift}:''${VERSION:-latest}"; then
          printf '%s\n' 'Failed to update the Zwift image; trying the cached image.' >&2
        fi
      fi
    '';
  };
}
