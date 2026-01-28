{...}: {
  imports = [
    ../../home/profiles/macos.nix
  ];

  home.username = "wyattgill";
  home.homeDirectory = "/Users/wyattgill";
  home.stateVersion = "24.05";

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
