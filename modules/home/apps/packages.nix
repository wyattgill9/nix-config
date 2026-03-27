{pkgs, ...}: {
  home.packages = with pkgs; [
    google-chrome
    spotify
    zoom-us
    thunar
  ];
}
