{
  config,
  lib,
  ...
}: let
  desktop = config.nx.desktop;
  modifier = "Mod4";
  workspaceBindings = lib.listToAttrs (map (workspace: {
      name = "${modifier}+${workspace}";
      value = "workspace number ${workspace}";
    })
    desktop.workspaceNumbers);
  moveToWorkspaceBindings = lib.listToAttrs (map (workspace: {
      name = "${modifier}+Shift+${workspace}";
      value = "move container to workspace number ${workspace}";
    })
    desktop.workspaceNumbers);
in {
  wayland.windowManager.sway = {
    enable = true;
    package = null;
    config = {
      bars = [];
      colors = {
        focused = {
          background = "#6a6e80";
          border = "#6a6e80";
          childBorder = "#6a6e80";
          indicator = "#8bc1e5";
          text = "#ffffff";
        };
        focusedInactive = {
          background = "#1b1b2c";
          border = "#1b1b2c";
          childBorder = "#1b1b2c";
          indicator = "#1b1b2c";
          text = "#888888";
        };
        unfocused = {
          background = "#1b1b2c";
          border = "#1b1b2c";
          childBorder = "#1b1b2c";
          indicator = "#1b1b2c";
          text = "#888888";
        };
      };
      floating.modifier = modifier;
      gaps = {
        inner = 5;
        outer = 20;
      };
      input = {
        "type:keyboard".xkb_layout = "us";
        "type:pointer".accel_profile = "flat";
        "type:touchpad".natural_scroll = "disabled";
      };
      keybindings =
        {
          "${modifier}+Shift+z" = "exec ${desktop.launcherCommand}";
          "${modifier}+q" = "exec ${desktop.terminal}";
          "${modifier}+c" = "kill";
          "${modifier}+m" = "exit";
          "${modifier}+e" = "exec ${desktop.fileManager}";
          "${modifier}+f" = "fullscreen toggle";
          "${modifier}+v" = "floating toggle";
          "${modifier}+r" = "exec ${desktop.menuCommand}";
          "${modifier}+j" = "layout toggle split";
          "${modifier}+Left" = "focus left";
          "${modifier}+Right" = "focus right";
          "${modifier}+Up" = "focus up";
          "${modifier}+Down" = "focus down";
          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Right" = "move right";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+c" = "reload";
        }
        // workspaceBindings
        // moveToWorkspaceBindings;
      menu = desktop.menuCommand;
      modifier = modifier;
      seat."seat0".xcursor_theme = "Adwaita 24";
      startup = [
        {command = "waybar";}
        {command = "fcitx5 -d";}
        {command = "lxqt-policykit-agent";}
      ];
      terminal = desktop.terminal;
      window.border = 2;
    };
    extraConfig = lib.concatStringsSep "\n" (desktop.sway.outputs ++ desktop.sway.workspaceAssignments);
  };
}
