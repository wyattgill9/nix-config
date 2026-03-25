{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
    # inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
  ];
}
