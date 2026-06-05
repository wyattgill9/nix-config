{
  inputs,
  pkgs,
  ...
}:
{
  programs.obs-studio = {
    enable = true;

    plugins = [
      pkgs.obs-studio-plugins.obs-pipewire-audio-capture
      pkgs.obs-studio-plugins.obs-vaapi
    ];
  };

  programs.anki = {
    enable = true;
    language = "en_US";
  };

  home.packages = [
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.google-chrome
    pkgs.firefox

    pkgs.discord
    pkgs.element-desktop
    pkgs.zoom-us
    pkgs.slack
    inputs.linear-linux.packages.${pkgs.stdenv.hostPlatform.system}.default

    pkgs.spotify
    pkgs.obsidian
    pkgs.thunar
    pkgs.thunderbird
    pkgs.easyeffects
    pkgs.vlc
    pkgs.foot

    pkgs.lunar-client
  ];
}
