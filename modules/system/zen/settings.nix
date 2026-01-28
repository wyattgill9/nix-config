{pkgs, ...}: {
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    settings = {
      auto-optimise-store = true;
      trusted-substituters = [
        "https://cache.nixos.org/"
        "https://wyattgill9.cachix.org"
        "https://cache.iog.io" # Haskell.nix
      ];

      trusted-public-keys = [
        "wyattgill9.cachix.org-1:o7wwgwm7n42DP4ps1GIAkVuxmYDxGZeHl1XMSs2sITU="
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" # Haskell.nix
      ];

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  environment.defaultPackages = with pkgs; [
    cachix
  ];
}
