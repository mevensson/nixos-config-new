{ pkgs, ... }:
{
  programs.vscode = {
    extensions = with pkgs.vscode-extensions; [
      redhat.vscode-yaml
    ];
  };
}
