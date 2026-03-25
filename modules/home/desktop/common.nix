{
  config,
  lib,
  nxLib,
  pkgs,
  ...
}: {
  options.nx.desktop = {
    fileManager = lib.mkOption {
      type = lib.types.str;
      default = "thunar";
      description = "Primary file manager command.";
    };
    hyprland.monitor = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Host-specific Hyprland monitor definitions.";
    };
    hyprland.workspaceAssignments = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Workspace-to-monitor assignments for Hyprland.";
    };
    launcherCommand = lib.mkOption {
      type = lib.types.str;
      default = "rofi -show drun -theme ~/.config/rofi/config.rasi";
      description = "Launcher command used for explicit app selection.";
    };
    menuCommand = lib.mkOption {
      type = lib.types.str;
      default = "rofi --show drun";
      description = "Menu command for window managers that expect a generic app launcher.";
    };
    modKey = lib.mkOption {
      type = lib.types.str;
      default = "SUPER";
      description = "Primary Hyprland modifier key.";
    };
    sway.outputs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Host-specific Sway output definitions.";
    };
    sway.workspaceAssignments = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Workspace-to-output assignments for Sway.";
    };
    terminal = lib.mkOption {
      type = lib.types.str;
      default = "ghostty";
      description = "Primary terminal command.";
    };
    waybar.persistentWorkspaces = lib.mkOption {
      type = lib.types.attrsOf lib.types.int;
      default = {};
      description = "Waybar workspace persistence map.";
    };
    workspaceNumbers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = nxLib.workspaceNumbers 6;
      description = "Workspace numbers used by the desktop keybindings.";
    };
  };

  config = {
    home.packages = with pkgs; [
      adwaita-icon-theme
      libnotify
      lxqt.lxqt-policykit
      networkmanagerapplet
      pavucontrol
      thunar
      wl-clipboard
    ];

    home.sessionVariables = {
      XCURSOR_SIZE = "32";
      XCURSOR_THEME = "Adwaita";
    };
  };
}
