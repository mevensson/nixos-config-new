{ ... }:
{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/54b58a38-6b0b-4c8e-a35d-44e3e8a052ac";
    fsType = "btrfs";
    options = [ "subvol=@nixos-root" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/BE1C-EBF4";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/54b58a38-6b0b-4c8e-a35d-44e3e8a052ac";
    fsType = "btrfs";
    options = [ "subvol=@nixos-home" ];
  };

  fileSystems."/media/misc" = {
    device = "/dev/disk/by-uuid/b45fa06a-f470-4ac0-bbd6-492398ec12d4";
    fsType = "btrfs";
    options = [ "subvol=@misc" ];
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

  fileSystems."/media/btrfs-misc" = {
    device = "/dev/disk/by-uuid/b45fa06a-f470-4ac0-bbd6-492398ec12d4";
    fsType = "btrfs";
  };
}

