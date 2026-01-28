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
          
          # Add jj prompt
          fish_jj_prompt
          
          echo -n ' '
        
          if test $last_status -eq 0
              set_color green
          else
              set_color red
          end
          echo -n 'λ '
          set_color normal
        '';
        
        # https://gist.github.com/hroi/d0dc0e95221af858ee129fd66251897e
        fish_jj_prompt = ''
          command -sq jj; or return 1
          set -l info (
              jj log --no-graph --ignore-working-copy --color=always --revisions @ --template '
                      separate(" ",
                          bookmarks,
                          if(conflict, label("conflict", "conflict")),
                          if(divergent, label("divergent", "divergent")),
                          if(parents.len() > 1, label("merge", "merged")),
                          coalesce(
                              if(empty, label("empty", "empty")),
                              label("change", "change")
                          )
                  )
              ' 2>/dev/null
          )
          or return 1

          # Check if there are unpushed changes
          set -l unpushed (
              jj log --no-graph --color=never \
                  --revisions '::@- & ~::remote_bookmarks()' \
                  --limit 1 | wc -l
          )
          if test $unpushed -gt 0
              set info "$info" (set_color yellow)"↑"(set_color normal)
          end

          test -n "$info"; and printf ' (%s)' $info
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
