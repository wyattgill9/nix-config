{
  description = "rainyzen's flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    awww = {
      url = "git+https://codeberg.org/LGFae/awww";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "";
    };
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
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
    rawgrep = {
      url = "github:rakivo/rawgrep";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-stalkr = {
      url = "github:wyattgill9/nix-stalkr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    systems = [ "x86_64-linux" "aarch64-darwin" ];
    forAllSystems = fn: nixpkgs.lib.genAttrs systems (system: fn nixpkgs.legacyPackages.${system});
  in {
    formatter = forAllSystems (
      pkgs:
        pkgs.treefmt.withConfig {
          runtimeInputs = [ pkgs.alejandra ];
          settings = {
            on-unmatched = "info";
            formatter.alejandra = {
              command = "alejandra";
              includes = ["*.nix"];
            };
          };
        }
    );

    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShellNoCC {
        packages = [ pkgs.nixd ];
      };
    });

    nixosConfigurations.zen = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/zen/configuration.nix
        inputs.nix-flatpak.nixosModules.nix-flatpak
      ];
    };

    homeConfigurations = {
      "wyattgill@zen" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ./hosts/zen/home.nix
          inputs.nixcord.homeModules.nixcord
        ];
      };
      "wyattgill@mac" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        extraSpecialArgs = {inherit inputs;};
        modules = [./hosts/macos/home.nix];
      };
    };
  };
}
