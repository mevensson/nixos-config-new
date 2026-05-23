{ pkgs, lib, ... }: {
  hardware.graphics.enable32Bit = true;

  programs.steam = {
    enable = true;
  };

  # Disable setuid for bwrap
  security.wrappers.bwrap.setuid = lib.mkForce false;
}
