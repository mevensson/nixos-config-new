{ ... }: {
  nix.settings = [
    auto-optimise-store = true;
  ];
  nix.optimize = {
    automatic = true;
    dates = [
      "03:45"
    ];
  };
}
