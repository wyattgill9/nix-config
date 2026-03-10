{
  inputs,
  pkgs,
  ...
}: {
  programs.bat = {
    enable = true;
    config.pager = "less -FR";
  };

  home.packages = with pkgs; [
    # AI
    inputs.claude-code.packages.${pkgs.system}.claude-code
    inputs.codex-cli.packages  .${pkgs.system}.default

    neovim
    lazygit
    just
    ripgrep
    fzf
    fastfetch
    zip

    nodejs-slim_25
  ];
}
