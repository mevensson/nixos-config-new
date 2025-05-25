{
  imports = [
    ./user-settings.nix
    ./extensions/jnoortheen.nix-ide.nix
    ./extensions/mkhl.direnv.nix
    ./extensions/redhat.vscode-yaml.nix
    ./extensions/rust-lang.rust-analyzer.nix
  ];

  home.sessionVariables = {
    # Enable Wayland for Chrome and Election apps
    NIXOS_OZONE_WL = "1";
  };

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
  };
}
