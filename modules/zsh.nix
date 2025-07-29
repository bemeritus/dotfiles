{...}: {
  programs.zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
  
      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch";
      };
      history.size = 10000;
  };
}




