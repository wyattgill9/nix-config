{...}: {
  programs.nixcord = {
    enable = true;

    discord = {
      enable = true;
      branch = "canary";
    };

    config.plugins = {
      messageLogger.enable = true;
      showHiddenChannels.enable = true;
      spotifyControls.enable = true;
      voiceMessages.enable = true;
      memberCount.enable = true;
    };
  };
}
