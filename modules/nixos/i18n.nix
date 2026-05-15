{ pkgs, ... }:
{
  time.timeZone = "America/Los_Angeles";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = [
          pkgs.fcitx5-gtk
          pkgs.qt6Packages.fcitx5-chinese-addons
          pkgs.fcitx5-nord
        ];
      };
    };
    extraLocaleSettings = {
      LC_ALL = "en_US.UTF-8";
    };
  };

  fonts = {
    enableDefaultPackages = true;
    packages = [
      pkgs.nerd-fonts._0xproto
      pkgs.noto-fonts
    ];

    fontconfig.enable = true;
  };
}
