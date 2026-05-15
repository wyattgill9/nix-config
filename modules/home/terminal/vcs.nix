{
  email,
  fullName,
  jjName,
  ...
}:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = fullName;
        inherit email;
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
        inherit email;
      };
      ui = {
        default-command = "log";
        paginate = "never";
      };
    };
  };
}
