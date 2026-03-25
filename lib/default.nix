{lib}: {
  mkFeatureOption = description:
    lib.mkOption {
      type = lib.types.bool;
      default = true;
      inherit description;
    };

  workspaceNumbers = count: builtins.genList (index: toString (index + 1)) count;
}
