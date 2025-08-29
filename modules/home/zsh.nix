{...}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      extended = true;
    };

    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch --flake .#bemeritus";
    };
  };
}
