{ ... }: {
  system.autoUpgrade = {
    enable = true;
    flake = "github:mevensson/nixos-config-new";
    dates = "daily";
    persistent = true;
    randomizedDelaySec = "10m";
  };
}
