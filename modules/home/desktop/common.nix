{ pkgs, ... }:
{
  home.packages = with pkgs; [
    adwaita-icon-theme
    libnotify
    lxqt.lxqt-policykit
    networkmanagerapplet
    pavucontrol
    wl-clipboard
  ];

  home.sessionVariables = {
    XCURSOR_SIZE = "32";
    XCURSOR_THEME = "Adwaita";
  };
}
