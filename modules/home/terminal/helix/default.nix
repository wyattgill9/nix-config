{
  pkgs,
  lib,
  ...
}: {
  programs.helix.enable = true;

  home.packages = with pkgs; [
    markdown-oxide
  ];

  home.file.".config/helix" = {
    source = ./.;
    recursive = true;
  };

  home.activation.buildHelixGrammars = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH=${pkgs.git}/bin:${pkgs.stdenv.cc}/bin:$PATH
    ${pkgs.helix}/bin/hx --grammar fetch
    ${pkgs.helix}/bin/hx --grammar build
  '';
}
