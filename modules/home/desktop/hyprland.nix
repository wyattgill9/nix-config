{config, ...}: let
  desktop = config.nx.desktop;
  workspaceBindings = builtins.concatLists (map (workspace: [
      "$mainMod, ${workspace}, workspace, ${workspace}"
      "$mainMod SHIFT, ${workspace}, movetoworkspace, ${workspace}"
    ])
    desktop.workspaceNumbers);
in {
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    settings = {
      "$fileManager" = desktop.fileManager;
      "$mainMod" = desktop.modKey;
      "$menu" = desktop.menuCommand;
      "$terminal" = desktop.terminal;
      animations = {
        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];
        enabled = true;
      };
      bind =
        [
          "$mainMod SHIFT, Z, exec, ${desktop.launcherCommand}"
          "$mainMod, Q, exec, $terminal"
          "$mainMod, E, exec, $fileManager"
          "$mainMod, C, killactive"
          "$mainMod, F, fullscreen"
          "$mainMod, V, togglefloating"
          "$mainMod, H, movefocus, l"
          "$mainMod, L, movefocus, r"
          "$mainMod, K, movefocus, u"
          "$mainMod, J, movefocus, d"
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"
        ]
        ++ workspaceBindings
        ++ [
          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"
        ];
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      decoration = {
        active_opacity = 1.0;
        blur = {
          enabled = true;
          passes = 1;
          size = 5;
          vibrancy = 0.2;
        };
      };
      env = [
        "XCURSOR_THEME,Adwaita"
        "XCURSOR_SIZE,32"
      ];
      exec-once = [
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "awww-daemon"
        "waybar"
        "hyprctl setcursor Adwaita 24"
        "fcitx5 -d"
        "lxqt-policykit-agent"
      ];
      general = {
        border_size = 2;
        gaps_in = 5;
        gaps_out = 20;
        layout = "dwindle";
        "col.active_border" = "rgba(6a6e80ff) rgba(8bc1e5ee) 45deg";
        "col.inactive_border" = "rgba(1b1b2caa)";
      };
      input = {
        follow_mouse = 1;
        sensitivity = 0;
        touchpad.natural_scroll = false;
      };
      monitor = desktop.hyprland.monitor;
      windowrule = [
        "suppress_event maximize, match:class .*"
        "no_focus on, match:class ^$, match:title ^$, match:xwayland true, match:float true, match:fullscreen false, match:pin false"
      ];
      workspace = desktop.hyprland.workspaceAssignments;
    };
  };
}
