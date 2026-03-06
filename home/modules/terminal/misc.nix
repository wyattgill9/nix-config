{pkgs, ...}: {
  programs.bat = {
    enable = true;
    config.pager = "less -FR";
  };

  home.packages = with pkgs; [
    neovim
    claude-code

    fastfetch
    ripgrep
    fzf
    zip
    nodejs_25
  ];
}
