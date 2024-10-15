{ ... }:
{
  imports = [
    ../../profiles/core/disko/default.nix
    #    ../../profiles/core/disko/root-tmpfs.nix
    #    ../../profiles/core/disko/gpt.nix
    #    ../../profiles/core/disko/esp.nix
    #    ../../profiles/core/disko/luks-btrfs/default.nix
    #    ../../profiles/core/disko/luks-btrfs/nix.nix
  ];

  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=2G"
        "defaults"

        # set mode to 755, otherwise systemd will set it to 777, which cause problems.
        # relatime: Update inode access times relative to modify or change time.
        "mode=755"
      ];
    };
    disk = {
      main = {
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            esp = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                passwordFile = "/tmp/luks-password";
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
