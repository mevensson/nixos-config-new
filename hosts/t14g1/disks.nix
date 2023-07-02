{ ... }:
{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7f5f422d-517d-408a-b536-2b92472bcf60";
    fsType = "btrfs";
    options = [ "subvol=@" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/CE9E-3512";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/7f5f422d-517d-408a-b536-2b92472bcf60";
    fsType = "btrfs";
    options = [ "subvol=@home" ];
  };
}

