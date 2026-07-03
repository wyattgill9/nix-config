{pkgs, ...}: {
  programs.helix.enable = true;

  home = {
    packages = [
      pkgs.markdown-oxide
    ];

    file.".config/helix" = {
      source = ./.;
      recursive = true;
    };
  };
}
