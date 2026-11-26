{ config, lib, pkgs, ... }: {
  options.myConfigs.core.printing.enable = lib.mkEnableOption "printing and local printer discovery";

  config = lib.mkIf config.myConfigs.core.printing.enable {
    services = {
      printing = {
        enable = true;
        drivers = [ pkgs.hplip ];
      };
      avahi = {
        enable = true;
        nssmdns4 = true;
      };
    };
  };
}
