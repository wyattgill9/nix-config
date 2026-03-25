{...}: {
  nx.desktop = {
    hyprland.monitor = [
      "DP-3, 1920x1080@240, 1080x0, 1"
    ];
    hyprland.workspaceAssignments = [
      "1, monitor:DP-3"
      "2, monitor:DP-3"
      "3, monitor:DP-3"
      "4, monitor:DP-3"
      "5, monitor:DP-3"
      "6, monitor:DP-3"
    ];

    sway.outputs = [
      "output DP-3 mode 1920x1080@240Hz position 1080,0"
      "output HDMI-A-1 mode 1920x1080@60Hz position 0,-495 transform 270"
    ];
    sway.workspaceAssignments = [
      "workspace 1 output DP-3"
      "workspace 2 output DP-3"
      "workspace 3 output DP-3"
      "workspace 4 output DP-3"
      "workspace 5 output HDMI-A-1"
      "workspace 6 output HDMI-A-1"
    ];

    waybar.persistentWorkspaces = {
      "DP-3" = 6;
    };
  };
}
