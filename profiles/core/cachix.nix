{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    cachix
  ];

  nix = {
    settings = {
      substituters = [
        "https://mevensson-nixos-config.cachix.org"
      ];
      trusted-public-keys = [
        "mevensson-nixos-config.cachix.org-1:nTyMdA8pqMkgk0Amny05+p3ujTE90BTilJPMwceHSEQ="
      ];
    };
  };
}
