{ config, lib, pkgs, llm-agents, ... }:
let
  herdr = llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.herdr;
  pluginDir = "${config.xdg.configHome}/herdr/local-plugins/matte.auto-tabs";
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
      worktrees.directory = "~/git/worktrees";
    };
  };

  home.packages = [ pkgs.jq ];

  xdg.configFile = {
    "herdr/local-plugins/matte.auto-tabs/herdr-plugin.toml".source = ./plugin/herdr-plugin.toml;
    "herdr/local-plugins/matte.auto-tabs/auto-tabs.sh".source = ./plugin/auto-tabs.sh;
  };

  home.activation.linkHerdrAutoTabs =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if ! ${lib.getExe herdr} plugin list --json 2>/dev/null | ${pkgs.gnugrep}/bin/grep -qF 'matte.auto-tabs'; then
        ${lib.getExe herdr} plugin link "${pluginDir}" >/dev/null
      fi
    '';
}
