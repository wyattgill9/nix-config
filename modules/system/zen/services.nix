{pkgs, ...}: {
  services = {
    openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = true;
        AllowUsers = ["wyattgill"];
      };
    };

    printing.enable = true;

    dbus.enable = true;

    blueman.enable = true;

    displayManager.ly = {
      enable = true;
    };

    # Caps Lock -> Esc
    keyd = {
      enable = true;

      keyboards.default = {
        ids = ["*"];
        settings = {
          main = {
            capslock = "esc";
          };
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    lxqt.lxqt-policykit
  ];
}
