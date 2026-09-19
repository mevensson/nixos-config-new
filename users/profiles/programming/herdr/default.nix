{ pkgs, llm-agents, ... }: {
  programs.herdr = {
    enable = true;
    package = llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.herdr;
    settings = {
      onboarding = false;
      terminal.default_shell = "fish";
      theme.name = "catppuccin";
    };
  };
}
