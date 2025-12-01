{pkgs, ...}: let
  # Direnv forces download & build of fish shell to test, just skip it
  direnv-no-fish = pkgs.direnv.overrideAttrs (old: {
    nativeCheckInputs = with pkgs; [
      zsh
      writableTmpDirAsHomeHook
    ];

    checkPhase = ''
      runHook preCheck
      make test-zsh
      runHook postCheck
    '';
  });

  langs = [
    "cpp"
    "rust"
    "haskell"
    "scheme"
    "python"
  ];
in {
  programs = {
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      # zprof.enable = true;

      initContent = ''
        if [ "$(uname)" = "Darwin" ]; then
          . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        fi

        unset DEVELOPER_DIR

        eval "$(starship init zsh)"
        eval "$(zoxide init zsh)"

        autoload -Uz compinit
        typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
        if [ $(date +'%j') != $updated_at ]; then
          compinit -i
        else
          compinit -C -i
        fi

        source <(jj util completion zsh)
      '';

      shellAliases =
        {
          cd = "z";
          cdi = "zi";
          c = "clear";
          cat = "bat";
          ls = "lsd";
          cmk = "cmake -S . -B build -G Ninja && cmake --build build";
          vim = "nvim";
        }
        // builtins.listToAttrs (
          map (lang: {
            name = "${lang}-dev";
            value = "nix develop ~/nx#${lang} -c zsh";
          })
          langs
        );
    };

    direnv = {
      enable = true;
      package = direnv-no-fish;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
