{
  inputs,
  pkgs,
  ...
}: let
  # hyprland-pkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  hardware = {
    graphics = {
      enable = true;
      # package = pkgs.mesa;
      extraPackages = with pkgs; [
        libvdpau-va-gl
        libva-vdpau-driver
        mesa
        mesa.opencl
      ];
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
