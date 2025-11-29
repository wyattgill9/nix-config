{ pkgs, ... }:
let
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
in
{
  programs = {
    zsh = {
      enable = true;
      autosuggestion.enable = true;

      initContent = ''
        if [ "$(uname)" = "Darwin" ]; then
          . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        fi

        unset DEVELOPER_DIR

        eval "$(starship init zsh)"
        eval "$(zoxide init zsh)"

        autoload -U compinit
        compinit

        source <(jj util completion zsh)
      '';

      shellAliases = {
        cd = "z";
        cdi= "zi";
        c = "clear";
        cat = "bat";
        ls = "lsd";
        cmk = "cmake -S . -B build -G Ninja && cmake --build build";
      }
      // builtins.listToAttrs (
        map (lang: {
          name = "${lang}-dev";
          value = "nix develop ~/nx#${lang} -c zsh";
        }) langs
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
