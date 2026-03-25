{
  config,
  lib,
  nxLib,
  ...
}: let
  cfg = config.nx.nixos.flatpak;
in {
  options.nx.nixos.flatpak.enable = nxLib.mkFeatureOption "flatpak support";

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;

    services.flatpak.remotes = lib.mkOptionDefault [
      {
        name = "flathub-beta";
        location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
      }
    ];

    services.flatpak.update.auto.enable = false;
    services.flatpak.uninstallUnmanaged = false;

    services.flatpak.packages = [
      "org.vinegarhq.Sober"
    ];
  };
}
