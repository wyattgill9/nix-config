{pkgs, ...}: {
  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
    };
  };

  home.packages = with pkgs; [
    nixd # Nix LSP

    # neovim
    sd
    ripgrep
    fzf
    lsd
    tldr

    fastfetch
  ];
}
