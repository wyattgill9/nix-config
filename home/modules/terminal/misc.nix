{inputs, pkgs,...}: {
  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
    };
  };

  home.packages = with pkgs; [
    # nodejs_25

    inputs.nix-stalkr.packages.${pkgs.system}.default    

    neovim
    claude-code

    fastfetch
    ripgrep
    fzf
    zip
    nodejs_25
  ];
}
