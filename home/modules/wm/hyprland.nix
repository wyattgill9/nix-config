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
      monitor = HDMI-A-1, 1920x1080@60, 0x-495, 1 , transform, 1

      ##################
      ### WORKSPACES ###
      ##################

      # Right Monitor
      workspace = 1, monitor:DP-3
      workspace = 2, monitor:DP-3
      workspace = 3, monitor:DP-3
      workspace = 4, monitor:DP-3

      # Left Monitor
      workspace = 5, monitor:HDMI-A-1
      workspace = 6, monitor:HDMI-A-1

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
      bind = $mainMod, C, killactive,
      bind = $mainMod, M, exit,
      bind = $mainMod, E, exec, $fileManager
      bind = $mainMod, F,fullscreen
      bind = $mainMod, V, togglefloating,
      bind = $mainMod, R, exec, $menu
      bind = $mainMod, P, pseudo, # dwindle
      bind = $mainMod, J, togglesplit, # dwindle
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
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      bind = $mainMod, S, togglespecialworkspace, magic
      bind = $mainMod SHIFT, S, movetoworkspace, special:magic

      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow


      general {
          gaps_in = 5
          gaps_out = 20

          border_size = 2

          # Updated colors for a darker aesthetic
          col.active_border = rgba(6a6e80ff) rgba(8bc1e5ee) 45deg
          col.inactive_border = rgba(1b1b2caa)

          resize_on_border = false
          allow_tearing = false

          layout = dwindle
      }

      decoration {
          rounding = 10

          active_opacity = 1.0
          # inactive_opacity = 0.95 # Slightly transparent inactive windows for depth

          shadow {
              enabled = true
              range = 4
              render_power = 3
              color = rgba(1a1a1a80) # subtle shadow
          }

          blur {
              enabled = true
              size = 5
              passes = 1

              vibrancy = 0.2
          }
      }

      animations {
          enabled = yes, please :)

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

      dwindle {
          pseudotile = true
          preserve_split = true
      }

      master {
          new_status = master
      }

      misc {
          force_default_wallpaper = -1
          disable_hyprland_logo = false
      }


      #############
      ### INPUT ###
      #############

      input {
          kb_layout = us #, cn
          kb_variant =
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
