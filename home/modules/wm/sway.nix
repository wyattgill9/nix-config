{...}: {
  wayland.windowManager.sway = {
    enable = true;
    package = null;

    config = null;

    extraConfig = ''
      ################
      ### MONITORS ###
      ################

      output DP-3 mode 1920x1080@240Hz position 1080,0
      output HDMI-A-1 mode 1920x1080@60Hz position 0,-495 transform 270

      ##################
      ### WORKSPACES ###
      ##################

      workspace 1 output DP-3
      workspace 2 output DP-3
      workspace 3 output DP-3
      workspace 4 output DP-3
      workspace 5 output HDMI-A-1
      workspace 6 output HDMI-A-1

      ##################
      ### AUTO START ###
      ##################

      exec waybar
      exec fcitx5 -d
      exec lxqt-policykit-agent

      ###################
      ###  PROGRAMS   ###
      ###################

      set $terminal ghostty
      set $fileManager thunar
      set $menu rofi --show drun

      ################
      ### KEYBINDS ###
      ################

      set $mod Mod4

      bindsym $mod+Shift+z exec rofi -show drun -theme ~/.config/rofi/config.rasi
      bindsym $mod+q exec $terminal
      bindsym $mod+c kill
      bindsym $mod+m exit
      bindsym $mod+e exec $fileManager
      bindsym $mod+f fullscreen toggle
      bindsym $mod+v floating toggle
      bindsym $mod+r exec $menu
      bindsym $mod+j layout toggle split

      bindsym $mod+Left focus left
      bindsym $mod+Right focus right
      bindsym $mod+Up focus up
      bindsym $mod+Down focus down

      bindsym $mod+Shift+Left move left
      bindsym $mod+Shift+Right move right
      bindsym $mod+Shift+Up move up
      bindsym $mod+Shift+Down move down

      bindsym $mod+1 workspace number 1
      bindsym $mod+2 workspace number 2
      bindsym $mod+3 workspace number 3
      bindsym $mod+4 workspace number 4
      bindsym $mod+5 workspace number 5
      bindsym $mod+6 workspace number 6
      bindsym $mod+7 workspace number 7
      bindsym $mod+8 workspace number 8
      bindsym $mod+9 workspace number 9
      bindsym $mod+0 workspace number 10

      bindsym $mod+Shift+1 move container to workspace number 1
      bindsym $mod+Shift+2 move container to workspace number 2
      bindsym $mod+Shift+3 move container to workspace number 3
      bindsym $mod+Shift+4 move container to workspace number 4
      bindsym $mod+Shift+5 move container to workspace number 5
      bindsym $mod+Shift+6 move container to workspace number 6
      bindsym $mod+Shift+7 move container to workspace number 7
      bindsym $mod+Shift+8 move container to workspace number 8
      bindsym $mod+Shift+9 move container to workspace number 9
      bindsym $mod+Shift+0 move container to workspace number 10

      bindsym $mod+Shift+c reload

      # Mouse bindings (built-in to Sway)
      floating_modifier $mod normal

      #################
      ### APPEARANCE ##
      #################

      gaps inner 5
      gaps outer 20

      default_border pixel 2

      # Colors (focused windows)
      client.focused          #6a6e80 #6a6e80 #ffffff #8bc1e5 #6a6e80
      # Colors (unfocused windows)
      client.unfocused        #1b1b2c #1b1b2c #888888 #1b1b2c #1b1b2c
      client.focused_inactive #1b1b2c #1b1b2c #888888 #1b1b2c #1b1b2c

      #############
      ### INPUT ###
      #############

      input type:keyboard {
          xkb_layout us
      }

      input type:pointer {
          accel_profile flat
      }

      input type:touchpad {
          natural_scroll disabled
      }

      seat seat0 xcursor_theme Adwaita 24
    '';
  };
  home.sessionVariables = {
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "32";
  };
}
