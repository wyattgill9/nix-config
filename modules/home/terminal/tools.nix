{pkgs, ...}: {
  programs.bat = {
    enable = true;
    config.pager = "less -FR";
  };

  home.packages = with pkgs; [
    bun
    fastfetch
    fzf
    just
    lazygit
    neovim
    nodejs
    ripgrep
    zip
    elan
  ];
}
