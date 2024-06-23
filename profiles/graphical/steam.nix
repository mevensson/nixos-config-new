{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    steam
  ];

  hardware.graphics.enable32Bit = true;
  nixpkgs.config.allowUnfree = true;
}
