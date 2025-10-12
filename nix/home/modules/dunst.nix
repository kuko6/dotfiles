{ config, ... }:

{
  enable = true;
  settings = {
    global = {
      # monitor = 0;
      width = "(0, 250)";
      # height = "(0, 50)";
      offset = "10x40";
      font = "JetBrainsMono Nerd Font Bold 9";
      shrink = "yes";
      padding = 16;
      horizontal_padding = 16;
      frame_width = 0;
      frame_color = "#0000";
      separator_color = "frame";
      line_height = 4;
      markup = "full";
      format = ''%s\n%b'';
      alignment = "center";
      word_wrap = "yes";
      ignore_newline = "no";
      show_indicators = "no";
      startup_notification = false;
      hide_duplicate_count = true;
    };
    urgency_low = {
      background = "#1f2430";
      forefround = "#cccac2";
      timeout = 4;
    };
    urgency_normal = {
      background = "#1f2430";
      forefround = "#cccac2";
      timeout = 4;
    };
    urgency_critical = {
      background = "#1f2430";
      forefrond = "#cccac2";
      frame_color = "#0000";
      timeout = 4;
    };
  };
}
