{pkgs, ...}: {
  home.packages = with pkgs;
    [
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
      foot
    ];
}
