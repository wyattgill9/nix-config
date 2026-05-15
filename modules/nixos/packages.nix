{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.bind
    pkgs.cachix
    pkgs.curl
    pkgs.ethtool
    pkgs.git
    pkgs.home-manager
    pkgs.mosh
    pkgs.perf
  ];
}
