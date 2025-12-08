{ ... }:
{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/54b58a38-6b0b-4c8e-a35d-44e3e8a052ac";
    fsType = "btrfs";
    options = [ "subvol=@nixos-root" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F957-999B";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/54b58a38-6b0b-4c8e-a35d-44e3e8a052ac";
    fsType = "btrfs";
    options = [ "subvol=@nixos-home" ];
  };

  fileSystems."/media/steam" = {
    device = "/dev/disk/by-uuid/54b58a38-6b0b-4c8e-a35d-44e3e8a052ac";
    fsType = "btrfs";
    options = [ "subvol=@steam" ];
  };

  fileSystems."/media/btrfs-root" = {
    device = "/dev/disk/by-uuid/54b58a38-6b0b-4c8e-a35d-44e3e8a052ac";
    fsType = "btrfs";
  };
}

