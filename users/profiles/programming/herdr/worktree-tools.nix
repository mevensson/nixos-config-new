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

  rmWt = pkgs.writeShellApplication {
    name = "rm-wt";
    runtimeInputs = [
      pkgs.git
      pkgs.jq
      pkgs.coreutils
      pkgs.util-linux
      herdr
    ];
    text = builtins.readFile ./scripts/rm-wt.sh;
  };
in
{
  home.packages = [
    newWt
    rmWt
  ];

  home.file = {
    ".agents/skills/new-wt/SKILL.md".source = ./skills/new-wt/SKILL.md;
    ".agents/skills/rm-wt/SKILL.md".source = ./skills/rm-wt/SKILL.md;
  };
}
