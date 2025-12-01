{
  system,
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.awww.packages.${system}.awww
  ];
}
