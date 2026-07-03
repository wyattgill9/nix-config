{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.bind
    pkgs.curl
    pkgs.ethtool
    pkgs.git
    pkgs.home-manager
    pkgs.mosh
    pkgs.perf
  ];
}
