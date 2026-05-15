{ pkgs, ... }:
{
  programs.nh = {
    enable = true;
    clean.enable = true;
  };

  programs.bat = {
    enable = true;
    config.pager = "less -FR";
  };

  home.packages = [
    pkgs.bun
    pkgs.nodejs

    pkgs.just
    pkgs.ripgrep
    pkgs.fzf

    pkgs.zip

    pkgs.fastfetch
  ];
}
