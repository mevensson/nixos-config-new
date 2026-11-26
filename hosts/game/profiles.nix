{
  myConfigs.boot.systemd-boot.enable = true;
  myConfigs.core = {
    enable = true;
    cachix-deploy.enable = true;
  };
  myConfigs.graphical = {
    ghostty.enable = true;
    gnome.enable = true;
  };
  myConfigs.remotefs.sshfs.ds920.enable = true;
  myConfigs.shells = {
    core.enable = true;
    fish.enable = true;
  };
  myConfigs.sound.pipewire.enable = true;
}
