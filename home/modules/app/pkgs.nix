{pkgs,...}: {
  home.packages = with pkgs; [
    google-chrome
    zoom-us
    thunar
    spotify
    networkmanagerapplet
  ];
}
