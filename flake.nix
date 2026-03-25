{
  description = "rainyzen's flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    awww = {
      url = "git+https://codeberg.org/LGFae/awww";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;

    systems = ["x86_64-linux"];
    forAllSystems = fn: lib.genAttrs systems (system: fn nixpkgs.legacyPackages.${system});

    nxLib = import ./lib {inherit lib;};
    overlayList = import ./overlays {inherit inputs;};

    zen = {
      system = "x86_64-linux";
      hostName = "zen";
      username = "wyattgill";
      fullName = "Wyatt Gill";
      jjName = "wyattgill9";
      email = "wyattgill01@outlook.com";
      homeDirectory = "/home/wyattgill";
      userPublicKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAUNWNgYOg3y2uo+FTRYlyWapbcfl4yjspm02bYC/3Rs wyattgill01@outlook.com"
      ];
      hostPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgzuLPAnG9sfhfoz2tj7sdcdPparwW+kI+mUiNeCJPj root@zen";
    };

    zenPkgs = import nixpkgs {
      system = zen.system;
      config.allowUnfree = true;
      overlays = overlayList;
    };

    zenArgs =
      {
        inherit inputs nxLib overlayList;
      }
      // zen;
  in {
    formatter = forAllSystems (pkgs: pkgs.alejandra);

    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShellNoCC {
        packages = [pkgs.nixd];
      };
    });

    nixosConfigurations.${zen.hostName} = lib.nixosSystem {
      system = zen.system;
      specialArgs = zenArgs;
      modules = [
        ./hosts/zen/default.nix
      ];
    };

    homeConfigurations = {
      "${zen.username}@${zen.hostName}" = home-manager.lib.homeManagerConfiguration {
        pkgs = zenPkgs;
        extraSpecialArgs = zenArgs;
        modules = [
          ./hosts/zen/home.nix
          inputs.nixcord.homeModules.nixcord
          inputs.nix-index-database.homeModules.nix-index
        ];
      };
    };
  };
}
