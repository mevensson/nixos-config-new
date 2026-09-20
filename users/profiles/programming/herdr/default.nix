{ config, lib, pkgs, llm-agents, ... }:
let
  herdr = llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.herdr;
  pluginDir = "${config.xdg.configHome}/herdr/local-plugins/matte.auto-tabs";
  worktreesDir = "~/git/worktrees";
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

  home.activation.linkHerdrAutoTabs =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      rm -rf "${pluginDir}"
      install -d "${pluginDir}"
      install -m 0644 ${./plugin/herdr-plugin.toml} "${pluginDir}/herdr-plugin.toml"
      install -m 0755 ${./plugin/auto-tabs.sh} "${pluginDir}/auto-tabs.sh"
      ${lib.getExe herdr} plugin unlink matte.auto-tabs >/dev/null 2>&1 || true
      ${lib.getExe herdr} plugin link "${pluginDir}" >/dev/null
    '';
}
