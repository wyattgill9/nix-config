{pkgs, ...}: {
  programs.btop = {
    enable = true;
    package = pkgs.btop.override {
      rocmSupport = pkgs.stdenv.isLinux;
    };
    settings = {
      vim_keys = true;
      rounded_corners = true;
      proc_tree = true;
      show_gpu_info = "on";
      show_uptime = true;
      show_coretemp = true;
      cpu_sensor = "auto";
      show_disks = true;
      only_physical = true;
      io_mode = true;
      io_graph_combined = false;
    };
  };

  home.packages = [
    # pkgs.cava
  ];
}
