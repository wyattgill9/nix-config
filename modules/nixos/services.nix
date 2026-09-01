_: {
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
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    # TZDIR reaches graphical sessions here; the tzdata module only
    # sets it via environment.variables, which Hyprland/Steam never source.
    TZDIR = "/etc/zoneinfo";
  };
}
