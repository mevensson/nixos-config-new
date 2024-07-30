{ jovian, ... }:
{
  imports = [
    jovian.nixosModules.default
  ];

  nixpkgs.config.allowUnfree = true;

  # Jovian NixOS options, specific to the deck
  jovian = {
    steam = {
      enable = true;
      #autoStart = true;
      #user = "${username}";
      #desktopSession = "gnome";
    };
    devices = {
      steamdeck = {
        #enable = true;
      };
    };
    decky-loader = {
      #enable = true;
    };
  };
}
