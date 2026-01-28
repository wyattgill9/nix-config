{...}: {
  imports = [
    ./hardware.nix
    ./bootloader.nix
    ./settings.nix
    ./network.nix
    ./programs.nix
    ./services.nix
    ./locale.nix
    ./pipewire.nix
    ./steam.nix
    ./flatpak.nix
    ./pkgs.nix
  ];
}
