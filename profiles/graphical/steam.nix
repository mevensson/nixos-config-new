{ pkgs, ... }: {
  hardware.graphics.enable32Bit = true;
  nixpkgs.config.allowUnfree = true;

  programs.steam = {
    enable = true;
  };
}
