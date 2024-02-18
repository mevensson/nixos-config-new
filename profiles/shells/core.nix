{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    htop
    tree
  ];
}
