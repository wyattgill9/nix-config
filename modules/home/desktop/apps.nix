{
  inputs,
  pkgs,
  ...
}: {
  programs.obs-studio = {
    enable = true;

    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
      obs-vaapi
    ];
  };

  programs.anki = {
    enable = true;
    language = "en_US";
  };

  home.packages = with pkgs; [
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    google-chrome
    firefox

    discord
    element-desktop
    spotify
    obsidian
    zoom-us
    thunar
    thunderbird
    vlc

    lunar-client
  ];
}
