{pkgs, ...}: {
  programs.nh = {
    enable = true;
    clean.enable = true;
  };
  
  programs.bat = {
    enable = true;
    config.pager = "less -FR";
  };

  home.packages = with pkgs; [
    bun
    nodejs

    just
    ripgrep
    fzf

    zip

    fastfetch
  ];
}
