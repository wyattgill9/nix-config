{
  email,
  fullName,
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
  };
}
