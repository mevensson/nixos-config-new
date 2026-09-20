{ config, lib, pkgs, llm-agents, ... }:
let
  herdr = llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.herdr;
  worktreesDir = "~/git/worktrees";
  herdrSkill = pkgs.runCommand "herdr-skill" { } ''
    ${lib.getExe herdr} --skill > $out
  '';
in
{
  programs.herdr = {
    enable = true;
    package = herdr;
    settings = {
      onboarding = false;
      terminal.default_shell = "fish";
      theme.name = "catppuccin";
      ui.sound.enabled = false;
      ui.toast.delivery = "system";
      worktrees.directory = worktreesDir;
    };
  };

  programs.direnv.config.whitelist.prefix = [ worktreesDir ];

  home.packages = [ pkgs.jq ];

  home.file.".agents/skills/herdr/SKILL.md".source = herdrSkill;
}
