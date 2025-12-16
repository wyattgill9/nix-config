{
  pkgs,
  inputs ? {},
  ...
}: {
  imports = [
    ./hardware.nix
    ../../modules/system/zen
    inputs.home-manager.nixosModules.home-manager
  ];

  users.users.wyattgill = {
    isNormalUser = true;
    description = "wyattgill";
    extraGroups = [
      "libvirtd"
      "networkmanager"
      "wheel"
      "kvm"
      "input"
      "seat"
    ];
    shell = pkgs.zsh;
  };

  system.stateVersion = "24.05";
}
