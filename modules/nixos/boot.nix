{
  config,
  lib,
  nxLib,
  pkgs,
  ...
}: let
  cfg = config.nx.nixos.boot;
in {
  options.nx.nixos.boot.enable = nxLib.mkFeatureOption "bootloader and kernel configuration";

  config = lib.mkIf cfg.enable {
    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 10;
        };
        efi.canTouchEfiVariables = true;
      };
      kernelPackages = pkgs.linuxPackages_zen;
    };
  };
}
