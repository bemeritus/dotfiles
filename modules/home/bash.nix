{...}: {
  programs.bash = {
    enable = true;

    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch --flake .#bemeritus";
      zed = "zeditor .";
    };
  };
}
