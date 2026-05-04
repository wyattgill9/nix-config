{ ... }:
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    baseIndex = 1;

    extraConfig = ''
      set -g default-terminal "tmux-256color"
      set -s escape-time 0

      set -g status-style "fg=white,bg=black"
    '';
  };
}
