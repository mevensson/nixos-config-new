{
  myConfigs.boot.systemd-boot.enable = true;
  myConfigs.core = {
    enable = true;
    cachix-deploy.enable = true;
  };
  myConfigs.graphical = {
    discord.enable = true;
    gamescope-steam-session.enable = true;
    gdm.enable = true;
    ghostty.enable = true;
    gnome.enable = true;
    libreoffice.enable = true;
    logitechg29.enable = true;
    spotify.enable = true;
    steam.enable = true;
  };
  myConfigs.llm.llama-swap = {
    enable = true;
    models = {
      gemma4-12b.enable = true;
      gemma4-26b.enable = true;
      qwen3-5-9b.enable = true;
    };
  };
  myConfigs.remotefs.sshfs.ds920.enable = true;
  myConfigs.shells = {
    core.enable = true;
    fish.enable = true;
  };
  myConfigs.sound.pipewire.enable = true;
}
