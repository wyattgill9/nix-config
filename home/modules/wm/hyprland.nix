{...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    extraConfig = "
      ################
      ### MONITORS ###
      ################

      monitor = DP-3, 1920x1080@240, 1080x0, 1
      # monitor = HDMI-A-1, 1920x1080@60, 0x-495, 1 , transform, 1

      ##################
      ### WORKSPACES ###
      ##################

      # Right (Main) Monitor
      workspace = 1, monitor:DP-3
      workspace = 2, monitor:DP-3
      workspace = 3, monitor:DP-3
      workspace = 4, monitor:DP-3
      workspace = 5, monitor:DP-3
      workspace = 6, monitor:DP-3

      ##################
      ### AUTO START ###
      ##################

      exec-once = wl-paste --type text --watch cliphist store
      exec-once = wl-paste --type image --watch cliphist store

      exec-once = awww-daemon
          
      exec-once = waybar
      exec-once = hyprsunset

      exec-once = hyprctl setcursor Adwaita 24

      # exec-once = systemctl --user start hyprpolkitagent

      #Pinyin 
      exec-once = fcitx5 -d

      #Polkit
      exec-once = lxqt-policykit-agent

      ###################
      ###  PROGRAMS   ###
      ###################

      $terminal = ghostty
      $fileManager = thunar
      $menu = rofi --show drun

      ################
      ### HYPR ENV ###
      ################

      env = XCURSOR_THEME,Adwaita
      env = XCURSOR_SIZE,32

      ################
      ### KEYBINDS ###
      ################

      $mainMod = SUPER

      bind = $mainMod SHIFT, Z, exec, rofi -show drun -theme ~/.config/rofi/config.rasi     
      bind = $mainMod, Q, exec, $terminal
      bind = $mainMod, E, exec, $fileManager

      bind = $mainMod, C, killactive,
      bind = $mainMod, F, fullscreen

      bind = $mainMod, V, togglefloating,

      bind = $mainMod, H, movefocus, l
      bind = $mainMod, L, movefocus, r
      bind = $mainMod, K, movefocus, u
      bind = $mainMod, J, movefocus, d

      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7

      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7

      # Secret Workspace - IDK
      bind = $mainMod, S, togglespecialworkspace, magic
      bind = $mainMod SHIFT, S, movetoworkspace, special:magic

      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      general {
          gaps_in = 5
          gaps_out = 20

          border_size = 2

          col.active_border = rgba(6a6e80ff) rgba(8bc1e5ee) 45deg
          col.inactive_border = rgba(1b1b2caa)

          layout = dwindle
      }

      decoration {
          active_opacity = 1.0

          blur {
              enabled = true
              size = 5
              passes = 1

              vibrancy = 0.2
          }
      }

      animations {
          enabled = yes

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

      #############
      ### INPUT ###
      #############

      input {
          kb_layout  = # us # , cn
          kb_options = # grp:win_space_toggle,caps:escape
          kb_variant = #,qwerty
          kb_model = 
          kb_options =
          kb_rules =

          follow_mouse = 1

          sensitivity = 0

          touchpad {
              natural_scroll = false
          }
      }

      # Ignore maximize requests from apps. You'll probably like this.
      windowrulev2 = suppressevent maximize, class:.*

      # Fix Drag issues with XWayland
      windowrulev2 = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
    ";
  };
}
