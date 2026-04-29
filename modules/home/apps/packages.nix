{
  inputs,
  pkgs,
  ...
}: {
  programs.anki = {
    enable = true;
    language = "en_US";
  };

  home.packages = with pkgs; [
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    google-chrome

    discord
    obsidian
    spotify
    zoom-us
    thunar
    lunar-client
  ];
}
