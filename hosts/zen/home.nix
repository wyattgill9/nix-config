{pkgs, ...}: {
  imports = [
    ../../home/profiles/linux.nix
  ];

  nixpkgs.config.allowUnfree = true;
  home.username = "wyattgill";
  home.homeDirectory = "/home/wyattgill";
  home.stateVersion = "24.05";

  systemd.user.startServices = "sd-switch";
  programs.home-manager.enable = true;

  home.sessionVariables = {
    GTK_IM_MODULE = "";

    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";

    # WAYLAND_DISPLAY = "$WAYLAND_DISPLAY";
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
  };

  # hm pkgs
  home.packages = with pkgs; [
    dunst
    libnotify
    wl-clipboard
    # mplayer
    adwaita-icon-theme
  ];
}
