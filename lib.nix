{
  # Import every module in `dir` (`.nix` files and subdirectories) except its
  # own default.nix, so module dirs auto-discover their contents instead of
  # hand-maintaining an import list.
  importDir =
    dir:
    let
      entries = builtins.readDir dir;
      keep =
        name:
        entries.${name} == "directory" || (name != "default.nix" && builtins.match ".*\\.nix" name != null);
    in
    map (name: dir + "/${name}") (builtins.filter keep (builtins.attrNames entries));
}
