{pkgs, ...}: {
  home.packages = [
    pkgs.adwaita-icon-theme
    pkgs.libnotify
    pkgs.lxqt.lxqt-policykit
    pkgs.networkmanagerapplet
    pkgs.pavucontrol
    pkgs.wl-clipboard
  ];

  home.sessionVariables = {
    XCURSOR_SIZE = "32";
    XCURSOR_THEME = "Adwaita";
  };
}
