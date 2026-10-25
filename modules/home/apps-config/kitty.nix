{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    settings = {
      
      # Colors
      background_opacity = 0.6;
      background_blur = 1;
      
      # Cursor
      cursor_trail = 1;
      cursor_blink_interval = 0;
    };
    
    keybindings = {
      "ctrl+t" = " launch --cwd=current --type=overlay yazi";
    };
  };
}