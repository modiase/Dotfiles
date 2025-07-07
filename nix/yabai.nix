{ config, pkgs, ... }:

{
  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    config = {
      layout = "bsp";
      window_placement = "second_child";
      top_padding = 10;
      bottom_padding = 10;
      left_padding = 10;
      right_padding = 10;
      window_gap = 10;
      window_border = "on";
      window_border_width = 2;
      active_window_border_color = "0xff775759";
      normal_window_border_color = "0xff554444";
      insert_feedback_color = "0xffd75f5f";
      split_ratio = 0.50;
      auto_balance = "off";
      mouse_follows_focus = "on";
      focus_follows_mouse = "autofocus";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      mouse_drop_action = "swap";
    };
    extraConfig = ''
      # yabai -m rule --add app="^Calculator$" manage=off
      sudo yabai --load-sa
      yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
    '';
  };
}
