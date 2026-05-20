{ lib, ... }:
{
  services.flatpak = {
    enable = true;

    # remotes = lib.mkOptionDefault [
    #   {
    #     name = "flathub-beta";
    #     location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
    #   }
    # ];

    update.auto.enable = false;
    uninstallUnmanaged = false;
  };
}
