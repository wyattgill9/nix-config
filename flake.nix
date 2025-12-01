{
  description = "rainyzen's flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
    awww.url = "git+https://codeberg.org/LGFae/awww";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord.url = "github:kaylorben/nixcord";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    systems,
    treefmt-nix,
    ...
  } @ inputs: let
    mkHome = system: modules:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {inherit inputs system;};
        inherit modules;
      };

    eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
    treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
  in {
    formatter = eachSystem (pkgs: treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.wrapper);
    checks = eachSystem (pkgs: {
      formatting = treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.check self;
    });

    nixosConfigurations.zen = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
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
