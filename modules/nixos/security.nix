{
  config,
  homeDirectory,
  lib,
  nxLib,
  username,
  ...
}: let
  cfg = config.nx.nixos.security;
in {
  options.nx.nixos.security = {
    enable = nxLib.mkFeatureOption "agenix-backed secret management";
    manageTailscaleAuthKey = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use the agenix-managed tailscale auth key during activation.";
    };
    manageUserPassword = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use the agenix-managed user password hash during activation.";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      age.identityPaths = [
        "/etc/ssh/ssh_host_ed25519_key"
        "${homeDirectory}/.ssh/id_ed25519"
      ];
    }

    (lib.mkIf cfg.manageTailscaleAuthKey {
      age.secrets."tailscale-authkey" = {
        file = ../../secrets/tailscale-authkey.age;
        mode = "0400";
        owner = "root";
        group = "root";
      };

      services.tailscale.authKeyFile = config.age.secrets."tailscale-authkey".path;
    })

    (lib.mkIf cfg.manageUserPassword {
      age.secrets."user-password" = {
        file = ../../secrets/user-password.age;
        mode = "0400";
        owner = "root";
        group = "root";
      };

      users.users.${username}.hashedPasswordFile = config.age.secrets."user-password".path;
    })
  ]);
}
