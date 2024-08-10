{
  imports = [
    ./extensions/jnoortheen.nix-ide.nix
  ];

  programs.vscode = {
    enable = true;
  };
}
