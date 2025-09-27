{
  imports = [
    ./user-settings.nix
  ];

  home.sessionVariables = {
    # Enable Wayland for Chrome and Election apps
    NIXOS_OZONE_WL = "1";
  };

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
  };
}
