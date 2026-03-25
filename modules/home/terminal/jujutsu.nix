{
  email,
  jjName,
  pkgs,
  ...
}: {
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

  home.packages = with pkgs; [
    lazyjj
  ];
}
