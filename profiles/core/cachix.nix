{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    cachix
  ];

  nix = {
    settings = {
      substituters = [
        "https://mevensson-nixos-config.cachix.org"
        "https://cache.numtide.com"
      ];
      trusted-public-keys = [
        "mevensson-nixos-config.cachix.org-1:nTyMdA8pqMkgk0Amny05+p3ujTE90BTilJPMwceHSEQ="
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];
    };
  };
}
