# Declarative disk layout for a fresh install with btrfs instead of ext4.
# Not wired into the active nixosConfiguration yet — see the commented-out
# import in flake.nix. To use it:
#   1. Boot a NixOS live ISO on the target machine.
#   2. Adjust `disk.main.device` below if it's not /dev/sda.
#   3. nix run github:nix-community/disko -- --mode destroy,format,mount ./machines/disko.nix
#   4. Remove the fileSystems/swapDevices entries from hardware-configuration.nix
#      (disko generates them) and uncomment the disko lines in flake.nix.
#   5. nixos-install --flake .#bemeritus
{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/sda";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["fmask=0077" "dmask=0077"];
            };
          };
          swap = {
            size = "8G";
            content = {
              type = "swap";
            };
          };
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = ["-f"];
              subvolumes = {
                "/root" = {
                  mountpoint = "/";
                  mountOptions = ["compress=zstd" "noatime"];
                };
                "/home" = {
                  mountpoint = "/home";
                  mountOptions = ["compress=zstd" "noatime"];
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = ["compress=zstd" "noatime"];
                };
                "/log" = {
                  mountpoint = "/var/log";
                  mountOptions = ["compress=zstd" "noatime"];
                };
              };
            };
          };
        };
      };
    };
  };
}
