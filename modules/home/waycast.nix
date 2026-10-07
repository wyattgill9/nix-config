# ponytail: disabled, rofi (modules/home/rofi) used instead. waycast's own flake
# hardcodes rust-bin.stable."1.94.0" while its Cargo.toml now requires 1.96, so it
# cannot build. Re-enable this and the flake input once upstream bumps that toolchain.
_: {
  # imports = [inputs.waycast.homeModules.default];
  # programs.waycast.enable = true;
}
