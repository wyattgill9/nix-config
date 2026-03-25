{
  config,
  lib,
  nxLib,
  pkgs,
  ...
}: let
  cfg = config.nx.nixos.hardware;
in {
  options.nx.nixos.hardware.enable = nxLib.mkFeatureOption "graphics and bluetooth hardware support";

  config = lib.mkIf cfg.enable {
    hardware = {
      graphics = {
        enable = true;
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
  };
}
