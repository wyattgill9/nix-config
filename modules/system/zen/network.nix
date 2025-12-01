{pkgs, ...}: {
  networking = {
    hostName = "zen";
    useNetworkd = false;

    networkmanager = {
      enable = true;
      dns = "default";
    };
  };

  # powerManagement.powertop.enable = false;

  # systemd.services.disable-ethernet-powersave = {
  #   wantedBy = [ "multi-user.target" ];
  #   after = [ "network.target" "NetworkManager-wait-online.service" ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     ExecStart = ''
  #       ${pkgs.ethtool}/bin/ethtool -s eno1 wol d
  #       ${pkgs.ethtool}/bin/ethtool --set-eee eno1 eee off 2>/dev/null || true
  #     '';
  #   };
  # };

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    ethtool
    bind
  ];
}
