{ config, lib, pkgs, llm-agents, ... }:
let
  herdr = llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.herdr;

  newWt = pkgs.writeShellApplication {
    name = "new-wt";
    runtimeInputs = [
      pkgs.git
      pkgs.jq
      pkgs.coreutils
      pkgs.gnugrep
      herdr
    ];
    text = builtins.readFile ./scripts/new-wt.sh;
  };
in
{
  home.packages = [ newWt ];

  home.file.".agents/skills/new-wt/SKILL.md".source = ./skills/new-wt/SKILL.md;
}
