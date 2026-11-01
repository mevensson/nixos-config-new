{ pkgs, zwift, ... }: {
  imports = [ zwift.nixosModules.default ];

  programs.zwift = {
    enable = true;
    containerTool = "podman";
    networking = "host";
    # Update the launcher through Nix and pull container images manually.
    dontUpdate = true;
    disableBluetooth = true;
    privilegedContainer = false;
  };

  environment.systemPackages = with pkgs; [
    curl
    xhost
  ];

  # Preserve GPU access through rootless Podman's --group-add keep-groups.
  users.users.matte.extraGroups = [ "video" "render" ];

  # Companion bridging and network-connected trainer discovery.
  networking.firewall = {
    allowedUDPPorts = [ 3022 3024 ];
    allowedTCPPorts = [ 21587 21588 ];
  };
}
