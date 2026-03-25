{
  config,
  hostName,
  lib,
  nxLib,
  ...
}: let
  cfg = config.nx.nixos.networking;
in {
  options.nx.nixos.networking.enable = nxLib.mkFeatureOption "networking, firewall, and tailscale configuration";

  config = lib.mkIf cfg.enable {
    networking = {
      inherit hostName;
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
                dns = "192.168.86.1;1.1.1.1;8.8.8.8;";
              };
              ipv6.method = "auto";
            };
          };
        };
      };

      firewall = {
        enable = true;
        allowedTCPPorts = [22];
        allowedUDPPortRanges = [
          {
            from = 60000;
            to = 61000;
          }
        ];
      };
    };

    services.tailscale = {
      enable = true;
      extraSetFlags = ["--accept-dns=false"];
      extraUpFlags = ["--accept-dns=false"];
    };
  };
}
