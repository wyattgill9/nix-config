{
  homeDirectory,
  username,
  ...
}: {
  imports = [
    ../../modules/home
  ];

  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "24.05";
  home.preferXdgDirectories = true;

  systemd.user.startServices = "sd-switch";
  programs.home-manager.enable = true;

  xdg = {
    enable = true;
    userDirs.enable = true;
  };

  home.sessionVariables = {
    GTK_IM_MODULE = "";

    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";

    # WAYLAND_DISPLAY = "$WAYLAND_DISPLAY";
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
  };
}
