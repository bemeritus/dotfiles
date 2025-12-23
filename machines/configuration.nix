# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./keyboards/default.nix
  ];

  nixpkgs = {
    overlays = [
      inputs.mac-style-plymouth.overlays.default
      inputs.nix4vscode.overlays.default
    ];
  };

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        devices = ["nodev"];
        #splashImage = ./background.png;
        useOSProber = true;
        efiSupport = true;
        theme = "${
          (pkgs.fetchFromGitHub {
            owner = "xinux-org";
            repo = "bootloader-theme";
            tag = "v1.0.3";
            hash = "sha256-ipaiJiQ3r2B3si1pFKdp/qykcpaGV+EqXRwl6UkCohs=";
          })
        }/xinux";
      };
    };

    plymouth = {
      enable = true;
      theme = "mac-style";
      themePackages = [pkgs.mac-style-plymouth];
    };

    consoleLogLevel = 3;
    initrd.systemd.enable = true;
    initrd.verbose = false;
    kernelParams = [
      "i915.modeset=1"
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
  };
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "schedutil";

  networking.hostName = "bemeritus"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    nvidiaPersistenced = false;
    dynamicBoost.enable = false;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
      libvdpau
      libva-vdpau-driver
      libva
      vulkan-loader
      vulkan-validation-layers
    ];
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tashkent";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8"; # or change to "ru_RU.UTF-8" or "uz_UZ.UTF-8"

  i18n.defaultLocale = "en_US.UTF-8"; # or change to "en_US.UTF-8" or "ru_RU.UTF-8" or "uz_UZ.UTF-8"

  # Enable the X11 windowing system.
  #services.xserver = {
  #  enable = true;

  # Configure keymap in X11
  # xkb = {
  #  extraLayouts.uz-latin = {
  #   description = "Oʻzbekcha";
  #  languages = ["eng" "uzb"];
  # symbolsFile = "${pkgs.fetchFromGitHub {
  #  owner = "bahrom04";
  # repo = "uzbek-latin-keyboard";
  #rev = "main";
  # hash = "sha256-rh6/QaYWpcS6oNUGT2EsVuQTEn5vTlM7uvKUr9AcviE=";
  # }}/uz";
  #};
  #layout = "us,uz-latin";
  # };
  # };

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable E-IMZO service.
  services.e-imzo.enable = true;

  services.flatpak.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # NVIDIA driver support
  services.xserver.videoDrivers = [
    "modesetting" # example for Intel iGPU; use "amdgpu" here instead if your iGPU is AMD
    "nvidia"
  ];

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
    enableSSHSupport = false;
  };

  programs.steam.enable = true;
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bemeritus = {
    isNormalUser = true;
    description = "BeMeritus";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
    packages = with pkgs; [
      thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = ["nix-command" "flakes"];

  #virtualisation.docker.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    fastfetch
    gnome-tweaks
    gnome-extension-manager
    ghostty
    #git
    #rustup
    #gcc
    # gnome-builder
    # flatpak
    # flatpak-builder
  ];

  # virtualisation = {
  #   libvirtd = {
  #     enable = true;
  #     qemu = {
  #       package = pkgs.qemu_kvm;
  #       runAsRoot = true;
  #       swtpm.enable = true;
  #       ovmf = {
  #         enable = true;
  #         packages = [
  #           (pkgs.OVMF.override {
  #             secureBoot = true;
  #             tpmSupport = true;
  #           })
  #           .fd
  #         ];
  #       };
  #     };
  #   };
  # };

  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    iosevka-bin
    julia-mono
    mononoki
    jetbrains-mono
  ];

  programs.starship.enable = true;
  programs.direnv.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
