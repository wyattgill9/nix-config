{inputs, pkgs,...}: {
  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
    };
  };

  home.packages = with pkgs; [
    inputs.nix-stalkr.packages.${pkgs.system}.default    
    inputs.fsel.packages.${pkgs.system}.default    

    neovim
    claude-code

    fastfetch

    ripgrep
    fzf
    lsd
    sd
    tldr
    nodejs_25

    zip
  ];
}
