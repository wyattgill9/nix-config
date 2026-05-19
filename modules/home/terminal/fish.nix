{
  programs = {
    direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
      silent = true;
    };

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
        set -g fish_greeting
        fish_config theme choose none
      '';

      shellAliases = {
        cat = "bat";
        c = "clear";
        cd = "z";
        cdi = "zi";
        cmk = "cmake -S . -B build -G Ninja && cmake --build build";
        vim = "nvim";
      };
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
