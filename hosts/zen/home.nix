{
  homeDirectory,
  username,
  ...
}: {
  imports = [
    ../../modules/home
  ];

  home = {
    inherit username homeDirectory;
    stateVersion = "24.05";
    preferXdgDirectories = true;
  };

  systemd.user.startServices = "sd-switch";
  programs.home-manager.enable = true;

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      setSessionVariables = false;
    };
  };

  home.sessionVariables = {
    GTK_IM_MODULE = "";

    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";

    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
  };
}
