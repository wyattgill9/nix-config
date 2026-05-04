{ ... }:
{
  nix = {
    channel.enable = false;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    nixPath = [ ];
    registry = { };

    settings = {
      auto-optimise-store = true;
      max-jobs = "auto";
      use-xdg-base-directories = true;
      warn-dirty = false;
      http-connections = 50;
      log-lines = 50;
      fallback = true;
      flake-registry = "";

      substituters = [
        "https://cache.nixos.org/"
        "https://cache.numtide.com"
        "https://wyattgill9.cachix.org"
        "https://cache.iog.io"
      ];

      trusted-public-keys = [
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        "wyattgill9.cachix.org-1:o7wwgwm7n42DP4ps1GIAkVuxmYDxGZeHl1XMSs2sITU="
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      ];

      trusted-users = [
        "root"
        "@wheel"
      ];

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.nix-index-database.comma.enable = true;
}
