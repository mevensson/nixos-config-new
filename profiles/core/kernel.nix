{ config
, lib
, pkgs
, ...
}: {
  options.myConfigs.core.kernel.enable = lib.mkEnableOption "the latest-kernel profile";

  config = lib.mkIf config.myConfigs.core.kernel.enable {
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.kernelParams = [
      "drm.debug=0x4"
    ];
  };
}
