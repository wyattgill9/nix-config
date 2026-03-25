{
  config,
  lib,
  nxLib,
  pkgs,
  ...
}: let
  cfg = config.nx.nixos.packages;
in {
  options.nx.nixos.packages.enable = nxLib.mkFeatureOption "system-wide packages";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bind
      cachix
      curl
      ethtool
      git
      home-manager
      mosh
      perf
    ];
  };
}
