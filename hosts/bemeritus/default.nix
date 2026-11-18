# Host-specific configuration for the work desktop "bemeritus".
# Shared system config lives in ../../common/configuration.nix and is
# composed in by mkHost in flake.nix.
{...}: {
  imports = [
    # Result of the hardware scan for this machine.
    ./hardware-configuration.nix

    # Uncomment when reinstalling with the btrfs layout in ./disko.nix
    # (and drop the fileSystems/swapDevices from hardware-configuration.nix
    # so they don't conflict). The disko module is added in flake.nix.
    # ./disko.nix
  ];

  networking.hostName = "bemeritus";

  # Bootloader (GRUB on EFI, with OS prober for dual boot).
  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      devices = ["nodev"];
      #splashImage = ./background.png;
      useOSProber = true;
      efiSupport = true;
    };
  };

  # Intel GPU / kernel tuning for this machine.
  boot.kernelParams = [
    "i915.modeset=1"
    "boot.shell_on_fail"
    # "ipv6.disable=1"
  ];
}
