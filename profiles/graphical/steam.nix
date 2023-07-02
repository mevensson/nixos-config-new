{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    steam
  ];

  nixpkgs.config.allowUnfree = true;
}
