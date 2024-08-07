{
  fileSystems."/media/ds920/Media" = {
    device = "matte@ds920.local:/Media";
    fsType = "sshfs";
    options = [
      "nodev"
      "noatime"
      "allow_other"
      "idmap=user"
      "IdentityFile=/run/agenix/matte_id_ed25519"
      "_netdev"
      "x-systemd.automount"
      "x-systemd.idle-timeout=600"
      "port=2222"
    ];
  };

  services.openssh.knownHosts = {
    ds920 = {
      hostNames = [
        "ds920.local"
      ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHLn9ETNjjj49yGV+0xTmbD4oWYXXGWYn96Kn9ZT0lAC";
    };
  };
}
