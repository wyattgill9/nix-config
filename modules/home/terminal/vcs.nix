{
  email,
  fullName,
  jjName,
  ...
}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = fullName;
        email = email;
      };
    };
    signing = {
      format = null;
    };
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = jjName;
        email = email;
      };
      ui = {
        default-command = "log";
        paginate = "never";
      };
    };
  };
}
