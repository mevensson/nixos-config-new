{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    oversteer
  ];

  hardware.new-lg4ff.enable = true;

  services.udev.packages = with pkgs; [
    oversteer
  ];
}
