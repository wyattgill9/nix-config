{pkgs, ...}: {
  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
    };
  };

  home.packages = with pkgs; [
    neovim
    sd
    ripgrep
    fzf
    lsd
    tldr

    fastfetch
  ];
}
