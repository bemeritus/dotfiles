{...}: {
  programs.git = {
    enable = true;

    settings.user.name = "bemerituss";
    settings.user.email = "bemerituss@gmail.com";

    signing = {
      signByDefault = true;
      key = "877D13DCB66D174974F06DB748B044A189147538";
    };

    # extraConfig = {
    #   init.defaultBranch = "main";
    #   http.sslVerify = false;
    #   pull.rebase = false;
    # };
  };
}
