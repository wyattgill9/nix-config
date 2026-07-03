{inputs, ...}: {
  imports = [inputs.waycast.homeModules.default];

  programs.waycast.enable = true;
}
