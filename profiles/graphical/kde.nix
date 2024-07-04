{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
  ];

  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.ksshaskpass.out}/bin/ksshaskpass";

  services = {
    desktopManager = {
      plasma6 = {
        enable = true;
      };
    };
  };
}
