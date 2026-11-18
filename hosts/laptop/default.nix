# Host-specific configuration for the laptop "laptop".
# Shared system config lives in ../../common/configuration.nix and is
# composed in by mkHost in flake.nix.
{...}: {
  imports = [
    # Result of the hardware scan for THIS laptop.
    # Generate it on the laptop and overwrite the placeholder:
    #   sudo nixos-generate-config --show-hardware-config \
    #     > hosts/laptop/hardware-configuration.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "laptop";

  # Bootloader. Laptops are usually single-OS EFI, so systemd-boot is
  # simplest. Switch to the GRUB block from hosts/bemeritus if you dual
  # boot.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Assumes an Intel GPU like the desktop. If this laptop has AMD, drop
  # the i915 line (and set the right videoDrivers in common if needed).
  boot.kernelParams = [
    "i915.modeset=1"
    "boot.shell_on_fail"
  ];

  # Laptop niceties.
  services.libinput.enable = true; # touchpad
  # GNOME already pulls in power-profiles-daemon for battery management.
  # Do NOT also enable services.tlp — the two conflict.
}
