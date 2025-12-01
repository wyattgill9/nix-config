{lib, ...}: {
  programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "\${custom.jj}"
        "$line_break"
        "$time"
        "$character"
      ];

      add_newline = true;
      scan_timeout = 10;
      command_timeout = 100;

      character = {
        success_symbol = "[λ](bold green)";
        error_symbol = "[λ](bold red)";
      };

      username = {
        format = "[$user]($style) ";
        style_user = "blue bold";
        show_always = true;
      };

      hostname = {
        format = "on [$hostname](bold yellow) ";
        ssh_only = false;
      };

      directory = {
        format = "in [$path]($style) ";
        style = "bold cyan";
        truncation_length = 2;
        truncate_to_repo = true;
      };

      # Disable git modules when in a jj repo
      git_branch = {
        disabled = true;
      };

      custom.git_branch = {
        when = "! jj --ignore-working-copy root";
        command = "starship module git_branch";
        style = "";
        description = "Only show git_branch if we're not in a jj repo";
      };

      # JJ status module
      custom.jj = {
        command = ''
          jj log --revisions @ --limit 1 --ignore-working-copy --no-graph --color always --template '
            separate(" ",
              bookmarks.map(|x| truncate_end(10, x.name(), "…")).join(" "),
              tags.map(|x| truncate_end(10, x.name(), "…")).join(" "),
              surround("\"", "\"", truncate_end(24, description.first_line(), "…")),
              if(conflict, "conflict"),
              if(divergent, "divergent"),
              if(hidden, "hidden"),
            )
          '
        '';
        when = "jj --ignore-working-copy root";
        symbol = "";
      };

      time = {
        format = "\\[ $time \\] ";
        time_format = "%H:%M:%S";
        style = "bold dimmed white";
        disabled = false;
      };

      line_break = {
        disabled = false;
      };
    };
  };
}
