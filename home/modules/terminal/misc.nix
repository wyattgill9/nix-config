{inputs, pkgs,...}: {
  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
    };
  };

  home.packages = with pkgs; [
    # nodejs_25

    neovim
    claude-code

    fastfetch
    ripgrep
    fzf
    zip
    nodejs_25
  ];
}
