{ pkgs, ... }:
{
  hardware = {
    graphics = {
      enable = true;
      extraPackages = [
        pkgs.libvdpau-va-gl
        pkgs.libva-vdpau-driver
        pkgs.mesa
        pkgs.mesa.opencl
      ];
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
