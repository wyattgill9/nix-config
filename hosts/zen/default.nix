{
  email,
  fullName,
  homeDirectory,
  hostName,
  inputs,
  jjName,
  pkgs,
  system,
  username,
  ...
}: {
  imports = [
    ./disko.nix
    ./hardware.nix
    ../../modules/nixos
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.nix-index-database.nixosModules.nix-index
  ];

  nixpkgs = {
    config.allowUnfree = true;
  };

  home-manager = {
    sharedModules = [
      inputs.nixcord.homeModules.nixcord
      inputs.nix-index-database.homeModules.nix-index
    ];
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit
        email
        fullName
        homeDirectory
        hostName
        inputs
        jjName
        system
        username
        ;
    };
    users.${username} = import ./home.nix;
  };

  users.users.${username} = {
    isNormalUser = true;
    description = fullName;
    extraGroups = [
      "libvirtd"
      "networkmanager"
      "wheel"
      "kvm"
      "input"
      "seat"
    ];
    shell = pkgs.fish;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGH1UfKsEvOGtb+6KdzGNL2BJ4fGefmsHRP7BG7fvHg4 wyattgill01@outlook.com"
    ];
  };

  system.stateVersion = "24.05";
}
