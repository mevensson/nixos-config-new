{
  imports = [
    ./user-settings.nix
    ./extensions/smcpeak.default-keys-windows.nix
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
