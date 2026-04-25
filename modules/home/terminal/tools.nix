{pkgs, ...}: {
  programs.bat = {
    enable = true;
    config.pager = "less -FR";
  };

  home.packages = with pkgs; [
    bun
    nodejs

    neovim
    lazygit

    just
    ripgrep
    fzf
    zip

    fastfetch
  ];
}
