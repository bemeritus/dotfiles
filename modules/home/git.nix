{...}: {
  programs.git = {
    enable = true;

    settings.user.name = "bemeritus";
    settings.user.email = "bemerituss@gmail.com";

    signing = {
     signByDefault = true;
     key = "41CB3CADA2D8627FEA8EB3103395DF64A98EC60A";
    };

    # extraConfig = {
    #   init.defaultBranch = "main";
    #   http.sslVerify = false;
    #   pull.rebase = false;
    # };
  };
}
