{ ... }: {
  nix.settings = {
    auto-optimise-store = true;
  };
  nix.optimise = {
    automatic = true;
    dates = [ "03:45" ];
  };
}
