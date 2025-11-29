{
  description = "rainyzen's flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    awww.url = "git+https://codeberg.org/LGFae/awww";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      # util = import ./util.nix {
      #   defaultSystems = [
      #     "x86_64-linux"
      #     "aarch64-darwin"
      #   ];
      # };
    in
      {
        nixosConfigurations.zen = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/zen/configuration.nix ];
        };

        homeConfigurations."wyattgill@zen" = home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs self;
            system = "x86_64-linux";
          };
          modules = [
            ./hosts/zen/home.nix
          ];
        };

        homeConfigurations."wyattgill@mac" = home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
          extraSpecialArgs = {
            inherit inputs self;
            system = "aarch64-darwin";
          };
          modules = [
            ./hosts/macos/home.nix
          ];
        };
      };
}
