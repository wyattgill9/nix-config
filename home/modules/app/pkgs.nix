{pkgs, ...}: {
  home.packages = with pkgs; [
    google-chrome
    zoom-us
    xfce.thunar
    spotify
    networkmanagerapplet
  ];
}
