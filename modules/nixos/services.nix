{
  config,
  lib,
  nxLib,
  ...
}: let
  cfg = config.nx.nixos.services;
in {
  options.nx.nixos.services.enable = nxLib.mkFeatureOption "desktop-facing system services and wrappers";

  config = lib.mkIf cfg.enable {
    services = {
      printing.enable = true;

      blueman.enable = true;

      displayManager.ly.enable = true;

      keyd = {
        enable = true;
        keyboards.default = {
          ids = ["*"];
          settings.main.capslock = "esc";
        };
      };
    };

    programs = {
      appimage = {
        enable = true;
        binfmt = true;
      };

      fish.enable = true;

      hyprland.enable = true;

      nix-ld.enable = true;

      sway = {
        enable = true;
        wrapperFeatures.gtk = true;
      };
    };

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };
}
