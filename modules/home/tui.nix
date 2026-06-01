{
  inputs,
  pkgs,
  ...
}:
{
  programs.btop = {
    enable = true;
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
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex

    pkgs.neovim
    pkgs.lazygit
    pkgs.lazyjj
    pkgs.yazi
  ];
}
