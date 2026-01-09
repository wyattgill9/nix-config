{
  programs = {
    fish = {
      enable = true;

      interactiveShellInit = ''
        set -U fish_greeting ""
        fish_config theme choose none
        
        if test (uname) = "Darwin"
          source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        end

        set -e DEVELOPER_DIR

        starship init fish | source
        zoxide init fish | source

        jj util completion fish | source

        set -gx BUN_INSTALL "$HOME/.bun"
        fish_add_path "$BUN_INSTALL/bin"

        fish_add_path $HOME/.cargo/bin
      '';

      shellAliases = {
        "vim" = "nvim";
        "ls"  = "lsd";
        "cd"  = "z";
        "c"   = "clear";
        "cat" = "bat";
        "cmk" = "cmake -S . -B build -G Ninja && cmake --build build";
      };
 
      shellInit = ''
      '';
    };

    direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
      # silent = true;
    };
  };
}
