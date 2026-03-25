{
  config,
  lib,
  nxLib,
  pkgs,
  ...
}: let
  cfg = config.nx.nixos.gaming;
in {
  options.nx.nixos.gaming.enable = nxLib.mkFeatureOption "steam and gamescope support";

  config = lib.mkIf cfg.enable {
    programs = {
      steam = {
        enable = true;

        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = false;

        gamescopeSession.enable = true;

        extraCompatPackages = [pkgs.proton-ge-bin];
      };

      gamescope = {
        enable = true;
        capSysNice = true;
        args = [
          "--rt"
          "--expose-wayland"
        ];
      };
    };
  };
}
