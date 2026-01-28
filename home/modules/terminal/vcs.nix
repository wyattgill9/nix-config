{pkgs, ...}: {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "wyattgill9";
        email = "wyattgill01@outlook.com";
      };
      ui = {
        default-command = "log";
        paginate = "never";
      };
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Wyatt Gill";
        email = "wyattgill01@outlook.com";
      };
    };
  };

  home.packages = with pkgs; [
    lazyjj
  ];
}
