{pkgs, ...}: {
  networking = {
    hostName = "zen";
    useNetworkd = false;
    networkmanager = {
      enable = true;
      dns = "default";
      ensureProfiles = {
        profiles = {
          eno1-static = {
            connection = {
              id = "eno1-static";
              type = "ethernet";
              interface-name = "eno1";
            };
            ipv4 = {
              method = "manual";
              address1 = "192.168.86.25/24,192.168.86.1";
              dns = "192.168.86.1;";
            };
            ipv6 = {
              method = "auto";
            };
          };
        };
      };
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [22]; # SSH
      # allowedUDPPorts = [ ];
    };
  };

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    ethtool
    bind
  ];
}
