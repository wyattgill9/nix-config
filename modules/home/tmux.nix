_: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    baseIndex = 1;

    extraConfig = ''
      set -g default-terminal "tmux-256color"
      set -s escape-time 0

      set -g status-style "fg=white,bg=black"
      set-option -g status-position top

      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R
    '';
  };
}
