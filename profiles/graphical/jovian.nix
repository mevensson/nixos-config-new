{ jovian, chaotic, ... }:
{
  imports = [
    jovian.nixosModules.default
    chaotic.nixosModules.default
  ];

  nixpkgs.config.allowUnfree = true;

  hardware = {
    xone.enable = true;
    xpadneo.enable = true;
  };

  # Jovian NixOS options, specific to the deck
  jovian = {
    steam = {
      enable = true;
      autoStart = true;
      user = "matte";
      desktopSession = "gnome";
    };
    devices = {
      steamdeck = {
        enable = false;
      };
    };
    decky-loader = {
      enable = false;
    };
  };
}
