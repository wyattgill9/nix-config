_: {
  nix = {
    channel.enable = false;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    nixPath = [];
    registry = {};

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
      ];

      trusted-public-keys = [
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];

      trusted-users = [
        "root"
        "@wheel"
      ];

      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
      ];
    };
  };
}
