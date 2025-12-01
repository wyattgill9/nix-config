{
  pkgs,
  lib,
  ...
}: {
  programs.helix.enable = true;

  home.file.".config/helix" = {
    source = ./.;
    recursive = true;
  };

  home.activation.runSomething = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH=${pkgs.git}/bin:${pkgs.stdenv.cc}/bin:$PATH
    ${pkgs.helix}/bin/hx --grammar fetch
    ${pkgs.helix}/bin/hx --grammar build
  '';
}
