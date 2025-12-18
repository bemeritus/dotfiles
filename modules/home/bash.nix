{...}: {
  programs.bash = {
    enable = true;

    shellAliases = {
      ll = "ls -l";
      update = "git add. && sudo nixos-rebuild switch --flake .#bemeritus";
      zed = "zeditor .";
    };
  };
}
