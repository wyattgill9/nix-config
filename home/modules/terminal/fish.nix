{
  programs = {
    fish = {
      enable = true;

      functions = {
        fish_prompt = ''
          set -l last_status $status
        
          set_color cyan
          echo -n (prompt_pwd)
          set_color normal
          echo -n ' '
        
          if test $last_status -eq 0
              set_color green
          else
              set_color red
          end
          echo -n 'λ '
          set_color normal
        '';
      };

      interactiveShellInit = ''
        set -U fish_greeting ""
        fish_config theme choose none
        
        if test (uname) = "Darwin"
          source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        end

        set -e DEVELOPER_DIR

        # starship init fish | source
        zoxide init fish | source

        jj util completion fish | source

        set -gx BUN_INSTALL "$HOME/.bun"
        fish_add_path "$BUN_INSTALL/bin"

        fish_add_path $HOME/.cargo/bin
      '';

      shellAliases = {
        "vim" = "nvim";
        "cd"  = "z";
        "cdi" = "zi";
        "c"   = "clear";
        "cat" = "bat";
        "ns"  = "nix-stalkr";
        "cmk" = "cmake -S . -B build -G Ninja && cmake --build build";
      };
 
      shellInit = ''
      '';
    };

    direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
      silent = true;
    };
  };
}
