{pkgs, ...}: {
  home.file.".config/ghostty/shaders" = {
    source = ./shaders;
    recursive = true;
  };

  programs.ghostty = {
    enable = true;
    package =
      if pkgs.stdenv.isLinux
      then pkgs.ghostty
      else null;

    enableFishIntegration = true;
    installBatSyntax = pkgs.stdenv.isLinux;

    settings = {
      font-family = "0xProto Nerd Font";
      theme = "tokyonight_night";
      background-opacity = 0.8;

      keybind = [
        "super+h=goto_split:left"
        "super+l=goto_split:right"
      ];

      window-decoration = !pkgs.stdenv.isLinux; # The bar above
      gtk-titlebar = true;
      gtk-single-instance = true;

      # custom-shader-animation = true;
      # custom-shader = "shaders/cursor_warp.glsl";
    };

    themes = {
      tokyonight_night = {
        background = "#24283b";
        foreground = "#c0caf5";
        cursor-color = "#c0caf5";
        cursor-text = "#1d202f";
        selection-background = "#2e3c64";
        selection-foreground = "#c0caf5";
        palette = [
          "0=#1d202f"
          "1=#f7768e"
          "2=#9ece6a"
          "3=#e0af68"
          "4=#7aa2f7"
          "5=#bb9af7"
          "6=#7dcfff"
          "7=#a9b1d6"
          "8=#414868"
          "9=#ff899d"
          "10=#9fe044"
          "11=#faba4a"
          "12=#8db0ff"
          "13=#c7a9ff"
          "14=#a4daff"
          "15=#c0caf5"
        ];
      };
    };
  };
}
