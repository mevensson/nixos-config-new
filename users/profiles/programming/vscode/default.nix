{
  imports = [
    ./extensions/jnoortheen.nix-ide.nix
    ./extensions/redhat.vscode-yaml.nix
  ];

  programs.vscode = {
    enable = true;
  };
}
