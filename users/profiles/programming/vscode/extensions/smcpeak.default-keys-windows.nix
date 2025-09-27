{ pkgs, ... }:
{
  programs.vscode = {
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        smcpeak.default-keys-windows
      ];
    };
  };
}
