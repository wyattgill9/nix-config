{ pkgs, ... }:
{
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

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

    pkgs.fzf
    pkgs.ripgrep
    pkgs.fd
    pkgs.yq
    pkgs.ast-grep
    pkgs.just

    pkgs.zip

    pkgs.fastfetch
    pkgs.nushell
  ];
}
