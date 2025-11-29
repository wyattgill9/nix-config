{ pkgs, inputs, ... }:
{
  home.packages = [
    inputs.awww.packages.${pkgs.system}.awww
  ];
}
