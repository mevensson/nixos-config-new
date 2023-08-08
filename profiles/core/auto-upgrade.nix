{ ... }: {
  system.autoUpgrade = {
    enable = true;
    flake = "github:mevensson/nixos-config-new";
    dates = "weekly";
    persistent = true;
    randomizedDelaySec = "20m";
  };
}
