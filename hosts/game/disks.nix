{ ... }:
{
  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/a3e7c67e-e799-4ba9-a5d1-f2b988a8ec2a";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/BC49-E688";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/a3e7c67e-e799-4ba9-a5d1-f2b988a8ec2a";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };
}

