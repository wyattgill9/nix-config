{...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    settings = {};
    extraConfig = ''
      $fileManager = thunar
      $mainMod     = SUPER
      $menu        = rofi --show drun
      $terminal    = ghostty

      monitor = DP-3, 1920x1080@240, 1080x0, 1

      env = XCURSOR_THEME,Adwaita
      env = XCURSOR_SIZE,32

      exec-once = wl-paste --type text  --watch cliphist store
      exec-once = wl-paste --type image --watch cliphist store
      exec-once = awww-daemon
      exec-once = waybar
      exec-once = hyprctl setcursor Adwaita 24
      exec-once = fcitx5 -d
      exec-once = lxqt-policykit-agent

      workspace = 1, monitor:DP-3
      workspace = 2, monitor:DP-3
      workspace = 3, monitor:DP-3
      workspace = 4, monitor:DP-3
      workspace = 5, monitor:DP-3
      workspace = 6, monitor:DP-3

      bind = $mainMod SHIFT, Z, exec, rofi -show drun -theme ~/.config/rofi/config.rasi
      bind = $mainMod, Q, exec, $terminal
      bind = $mainMod, E, exec, $fileManager
      bind = $mainMod, C, killactive
      bind = $mainMod, F, fullscreen
      bind = $mainMod, V, togglefloating
      bind = $mainMod, H, movefocus, l
      bind = $mainMod, L, movefocus, r
      bind = $mainMod, K, movefocus, u
      bind = $mainMod, J, movefocus, d
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod, S, togglespecialworkspace, magic
      bind = $mainMod SHIFT, S, movetoworkspace, special:magic

      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      general {
          border_size = 2
          gaps_in = 5
          gaps_out = 20
          layout = dwindle
          col.active_border = rgba(6a6e80ff) rgba(8bc1e5ee) 45deg
          col.inactive_border = rgba(1b1b2caa)
      }

      input {
          follow_mouse = 1
          sensitivity = 0
          touchpad {
              natural_scroll = false
          }
      }

      decoration {
          active_opacity = 1.0
          blur {
              enabled = true
              passes = 1
              size = 5
              vibrancy = 0.2
          }
      }

      animations {
          enabled = true

          bezier = easeOutQuint,0.23,1,0.32,1
          bezier = easeInOutCubic,0.65,0.05,0.36,1
          bezier = linear,0,0,1,1
          bezier = almostLinear,0.5,0.5,0.75,1.0
          bezier = quick,0.15,0,0.1,1

          animation = global, 1, 10, default
          animation = border, 1, 5.39, easeOutQuint
          animation = windows, 1, 4.79, easeOutQuint
          animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
          animation = windowsOut, 1, 1.49, linear, popin 87%
          animation = fadeIn, 1, 1.73, almostLinear
          animation = fadeOut, 1, 1.46, almostLinear
          animation = fade, 1, 3.03, quick
          animation = layers, 1, 3.81, easeOutQuint
          animation = layersIn, 1, 4, easeOutQuint, fade
          animation = layersOut, 1, 1.5, linear, fade
          animation = fadeLayersIn, 1, 1.79, almostLinear
          animation = fadeLayersOut, 1, 1.39, almostLinear
          animation = workspaces, 1, 1.94, almostLinear, fade
          animation = workspacesIn, 1, 1.21, almostLinear, fade
          animation = workspacesOut, 1, 1.94, almostLinear, fade
      }

      windowrule = suppress_event maximize, match:class .*
      windowrule = no_focus on, match:class ^$, match:title ^$, match:xwayland true, match:float true, match:fullscreen false, match:pin false
    '';
  };
}
