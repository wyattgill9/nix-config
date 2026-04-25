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

    spotify
    zoom-us
    thunar
    lunar-client
  ];
}
