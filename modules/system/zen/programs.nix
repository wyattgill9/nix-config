{pkgs, inputs,...}: {
  programs = {
    fish.enable = true;

    nix-ld.enable = true;

    nix-index = {
      enable = true;
      enableFishIntegration = true;
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

  security.wrappers.rawgrep = {
    owner = "root";
    group = "root";
    capabilities = "cap_dac_read_search=eip";
    source = "${inputs.rawgrep.packages.${pkgs.system}.default}/bin/rawgrep";
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}
