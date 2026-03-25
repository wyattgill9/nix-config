{
  email,
  fullName,
  homeDirectory,
  hostName,
  hostPublicKey,
  inputs,
  jjName,
  nxLib,
  overlayList,
  pkgs,
  system,
  userPublicKeys,
  username,
  ...
}: {
  imports = [
    ./disko.nix
    ./hardware.nix
    ../../modules/nixos
    inputs.agenix.nixosModules.default
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.nix-index-database.nixosModules.nix-index
  ];

  nixpkgs = {
    config.allowUnfree = true;
    overlays = overlayList;
  };

  nx.nixos.security = {
    manageTailscaleAuthKey = false;
    manageUserPassword = false;
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
        hostPublicKey
        inputs
        jjName
        nxLib
        overlayList
        system
        userPublicKeys
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
    openssh.authorizedKeys.keys = userPublicKeys;
    shell = pkgs.fish;
  };

  system.stateVersion = "24.05";
}
