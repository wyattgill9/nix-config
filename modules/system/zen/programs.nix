{...}: {
  programs = {
    zsh.enable = true;

    nix-ld.enable = true;

    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };

    # APPIMAGES
    appimage = {
      enable = true;
      binfmt = true;
    };

    # HYPRLAND
    hyprland = {
      enable = true;
      # package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    };
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}
