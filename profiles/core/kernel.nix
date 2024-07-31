{ pkgs
, ...
}: {
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "drm.debug=0x4"
  ];
}
