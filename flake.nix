{
  description = "rainyzen's flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
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
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };
    awww = {
      url = "git+https://codeberg.org/LGFae/awww";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    # nixcord = {
    #   url = "github:kaylorben/nixcord";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.flake-compat.follows = "";
    # };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;

      systems = [ "x86_64-linux" ];
      forAllSystems = fn: lib.genAttrs systems (system: fn nixpkgs.legacyPackages.${system});

      zen = {
        system = "x86_64-linux";
        hostName = "zen";
        username = "wyattgill";
        fullName = "Wyatt Gill";
        jjName = "wyattgill9";
        email = "wyattgill01@outlook.com";
        homeDirectory = "/home/wyattgill";
      };

      zenPkgs = import nixpkgs {
        system = zen.system;
        config.allowUnfree = true;
      };

      zenArgs = {
        inherit inputs;
      }
      // zen;
    in
    {
      formatter = forAllSystems (pkgs: pkgs.alejandra);

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShellNoCC {
          packages = [ pkgs.nixd ];
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
            # inputs.nixcord.homeModules.nixcord
            inputs.nix-index-database.homeModules.nix-index
          ];
        };
      };
    };
}
