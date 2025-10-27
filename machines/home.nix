{pkgs, ...}: {
  imports = [
    ../modules/home/git.nix
    ../modules/home/bash.nix
    ../modules/home/starship.nix
    ../modules/home/zsh.nix
    ../modules/home/zed.nix
    ../modules/home/wezterm.nix
  ];

  # TODO please change the username & home directory to your own
  home.username = "bemeritus";
  home.homeDirectory = "/home/bemeritus";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    pfetch
    nnn
    btop
    errands
    resources
    telegram-desktop
    termius
    fractal
    bat
    aria2
    zola
    keepassxc
    openssl
    poedit
    yt-dlp
    stacer
    obsidian
    vscode
    floorp
    vivaldi
    gnome-boxes
    planify
    zulip
    discord-ptb
    spotify
    github-desktop
    health
    fragments
    popsicle
    pika-backup
    gnome-podcasts
    # amberol
    # (callPackage /home/bemeritus/Projects/e-imzo/default.nix {})
  ];

  # basic configuration of git, please change to your own

  # starship - an customizable prompt for any shell

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}
