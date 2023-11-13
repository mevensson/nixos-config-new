{ ... }: {
  system.autoUpgrade = {
    enable = true;
    flake = "github:mevensson/nixos-config-new";
    dates = "hourly";
    persistent = true;
    randomizedDelaySec = "10m";
  };
}
