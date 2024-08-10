{ pkgs, ... }:
{
  programs.vscode = {
    extensions = with pkgs.vscode-extensions; [
      mkhl.direnv
    ];
  };
}
