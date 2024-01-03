{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    steam
  ];

  hardware.opengl.driSupport32Bit = true;
  nixpkgs.config.allowUnfree = true;
}
