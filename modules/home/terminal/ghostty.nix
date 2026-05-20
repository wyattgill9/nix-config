_: {
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

      window-decoration = true;
      gtk-titlebar = true;
      gtk-single-instance = true;
    };
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    baseIndex = 1;

    extraConfig = ''
      set -g default-terminal "tmux-256color"
      set -s escape-time 0

      set -g status-style "fg=white,bg=black"
      set-option -g status-position top
    '';
  };
}
