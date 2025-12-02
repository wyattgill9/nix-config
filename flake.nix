{
  description = "rainyzen's flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    awww.url = "git+https://codeberg.org/LGFae/awww";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord.url = "github:kaylorben/nixcord";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    systems = ["x86_64-linux" "aarch64-darwin"];

    forAllSystems = nixpkgs.lib.genAttrs systems;

    mkHome = system: modules:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {inherit inputs system;};
        inherit modules;
      };
  in {
    formatter = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        pkgs.treefmt.withConfig {
          runtimeInputs = [pkgs.alejandra];
          settings = {
            on-unmatched = "info";
            formatter.alejandra = {
              command = "alejandra";
              includes = ["*.nix"];
            };
          };
        }
    );

    nixosConfigurations.zen = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/zen/configuration.nix
        inputs.nix-flatpak.nixosModules.nix-flatpak
      ];
    };

    homeConfigurations = {
      "wyattgill@zen" = mkHome "x86_64-linux" [
        ./hosts/zen/home.nix
        inputs.nixcord.homeModules.nixcord
      ];
      "wyattgill@mac" = mkHome "aarch64-darwin" [
        ./hosts/macos/home.nix
      ];
    };
  };
}
