{
  config,
  lib,
  nxLib,
  ...
}: let
  cfg = config.nx.nixos.audio;
in {
  options.nx.nixos.audio.enable = nxLib.mkFeatureOption "pipewire audio services";

  config = lib.mkIf cfg.enable {
    services.pulseaudio.enable = false;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    hardware.alsa.enablePersistence = true;
  };
}
