{pkgs, ...}: {
  programs.ghostty = {
    enable = true;

    enableFishIntegration = true;
    installBatSyntax = true;

    settings = {
      font-family = "0xProto Nerd Font";
      theme = "TokyoNight";
      background-opacity = 0.8;

      keybind = [
        "super+h=goto_split:left"
        "super+l=goto_split:right"
      ];

      window-decoration = !pkgs.stdenv.isLinux;
      gtk-titlebar = true;
      gtk-single-instance = true;
    };
  };
}
