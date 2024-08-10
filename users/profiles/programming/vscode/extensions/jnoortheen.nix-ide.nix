{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nixd
  ];

  programs.vscode = {
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
    ];

    userSettings = {
      "nix.serverPath" = "nixd";
    };
  };
}
