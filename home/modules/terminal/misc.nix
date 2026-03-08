{pkgs, ...}: {
  programs.bat = {
    enable = true;
    config.pager = "less -FR";
  };

  home.packages = with pkgs; [
    claude-code
    codex

    neovim
    just
    ripgrep
    fzf
    fastfetch
    zip

    nodejs_25
  ];
}
