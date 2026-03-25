{
  config,
  lib,
  nxLib,
  pkgs,
  ...
}: let
  cfg = config.nx.nixos.i18n;
in {
  options.nx.nixos.i18n.enable = nxLib.mkFeatureOption "locale, fonts, and input method configuration";

  config = lib.mkIf cfg.enable {
    time.timeZone = "America/Los_Angeles";

    i18n = {
      defaultLocale = "en_US.UTF-8";
      inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
          waylandFrontend = true;
          addons = with pkgs; [
            fcitx5-gtk
            qt6Packages.fcitx5-chinese-addons
            fcitx5-nord
          ];
        };
      };
      extraLocaleSettings = {
        LC_ALL = "en_US.UTF-8";
      };
    };

    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        nerd-fonts._0xproto
        noto-fonts
      ];

      fontconfig.enable = true;
    };
  };
}
