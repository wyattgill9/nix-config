{inputs, ...}: {
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    settings = {
      auto-optimise-store = true;
      max-jobs = "auto";

      substituters = [
        "https://cache.nixos.org/"
        "https://wyattgill9.cachix.org"
        "https://cache.iog.io" # Haskell.nix
      ];

      trusted-public-keys = [
        "wyattgill9.cachix.org-1:o7wwgwm7n42DP4ps1GIAkVuxmYDxGZeHl1XMSs2sITU="
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" # Haskell.nix
      ];

      trusted-users = ["root" "@wheel"];

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
