{ config, lib, ... }: {
  options.myConfigs.sound.pipewire.enable = lib.mkEnableOption "the PipeWire audio profile";

  config = lib.mkIf config.myConfigs.sound.pipewire.enable {
    security.rtkit.enable = true;

    services = {
      pulseaudio.enable = false;

      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    };
  };
}
