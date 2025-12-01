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

    enableZshIntegration = true;
    installBatSyntax = pkgs.stdenv.isLinux;

    settings = {
      font-family = "0xProto Nerd Font";
      window-decoration = !pkgs.stdenv.isLinux;
      gtk-titlebar = true;
      gtk-single-instance = true;

      # custom-shader-animation = true;
      # custom-shader = "shaders/cursor_warp.glsl";

      background-opacity = 0.8;
      theme = "tokyonight_night";
    };

    themes = {
      tokyonight_day = {
        background = "#e1e2e7";
        foreground = "#3760bf";
        cursor-color = "#3760bf";
        cursor-text = "#e1e2e7";
        selection-background = "#b7c1e3";
        selection-foreground = "#3760bf";
        palette = [
          "0=#b4b5b9"
          "1=#f52a65"
          "2=#587539"
          "3=#8c6c3e"
          "4=#2e7de9"
          "5=#9854f1"
          "6=#007197"
          "7=#6172b0"
          "8=#a1a6c5"
          "9=#ff4774"
          "10=#5c8524"
          "11=#a27629"
          "12=#358aff"
          "13=#a463ff"
          "14=#007ea8"
          "15=#3760bf"
        ];
      };

      tokyonight_moon = {
        background = "#222436";
        foreground = "#c8d3f5";
        cursor-color = "#c8d3f5";
        cursor-text = "#222436";
        selection-background = "#2d3f76";
        selection-foreground = "#c8d3f5";
        palette = [
          "0=#1b1d2b"
          "1=#ff757f"
          "2=#c3e88d"
          "3=#ffc777"
          "4=#82aaff"
          "5=#c099ff"
          "6=#86e1fc"
          "7=#828bb8"
          "8=#444a73"
          "9=#ff8d94"
          "10=#c7fb6d"
          "11=#ffd8ab"
          "12=#9ab8ff"
          "13=#caabff"
          "14=#b2ebff"
          "15=#c8d3f5"
        ];
      };

      tokyonight_storm = {
        background = "#1a1b26";
        foreground = "#c0caf5";
        cursor-color = "#c0caf5";
        cursor-text = "#1a1b26";
        selection-background = "#283457";
        selection-foreground = "#c0caf5";
        palette = [
          "0=#15161e"
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
