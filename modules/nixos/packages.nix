{
  inputs,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    bind
    cachix
    curl
    ethtool
    git
    home-manager
    mosh
    perf
  ];
}
