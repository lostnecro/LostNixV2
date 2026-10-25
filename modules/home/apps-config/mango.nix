{ pkgs, config, lib, inputs, ... }:

{
  imports = [ 
    inputs.mangowm.hmModules.mango 
  ];

  wayland.windowManager.mango = {
    enable = true;

    autostart_sh = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &
      
      killall -9 xdg-desktop-portal-wlr xdg-desktop-portal 2>/dev/null
      ${pkgs.xdg-desktop-portal-wlr}/libexec/xdg-desktop-portal-wlr &
      sleep 1
      ${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal &
      
      waybar &
      dunst &
      awww-daemon &
      fcitx5 -d &
      nm-applet &
    '';

    settings = {
      # Window effects
      blur = 1;
      blur_optimized = 1;
      blur_params = {
        radius = 5;
        num_passes = 2;
      };
      border_radius = 2;
      focused_opacity = 1.0;

      # Animations
      animations = 1;
      animation_type_open = "slide";
      animation_type_close = "slide";
      animation_duration_open = 200;
      animation_duration_close = 200;


      # Rules
      monitorrule = [
        "name:eDP-1,width:1920,height:1080,refresh:60,x:1920,y:0"
        "name:HDMI-A-1,width:1920,height:1080,refresh:100,x:0,y:0"
      ];
      tagrule = [
        "id:1,monitor_name:eDP-1,layout_name:scroller"
        "id:2,monitor_name:eDP-1,layout_name:scroller"
        "id:3,monitor_name:eDP-1,layout_name:scroller"
        "id:4,monitor_name:eDP-1,layout_name:scroller"
        "id:5,monitor_name:eDP-1,layout_name:scroller"
        "id:6,monitor_name:eDP-1,layout_name:scroller"
        "id:7,monitor_name:eDP-1,layout_name:scroller"
        "id:8,monitor_name:eDP-1,layout_name:scroller"
        "id:9,monitor_name:eDP-1,layout_name:scroller"

        "id:1,monitor_name:HDMI-A-1,layout_name:scroller"
        "id:2,monitor_name:HDMI-A-1,layout_name:scroller"
        "id:3,monitor_name:HDMI-A-1,layout_name:scroller"
        "id:4,monitor_name:HDMI-A-1,layout_name:scroller"
        "id:5,monitor_name:HDMI-A-1,layout_name:scroller"
        "id:6,monitor_name:HDMI-A-1,layout_name:scroller"
        "id:7,monitor_name:HDMI-A-1,layout_name:scroller"
        "id:8,monitor_name:HDMI-A-1,layout_name:scroller"
        "id:9,monitor_name:HDMI-A-1,layout_name:scroller"
      ];

      # Binds
      bind = [
        "SUPER,P,reload_config"
        "SUPER,R,spawn,rofi -show drun -show-icons"
        "SUPER,T,spawn,kitty nvim"
        "SUPER,Return,spawn,kitty"
        "SUPER,F1,spawn,bash ~/.config/lostshell/scripts/dmenu.sh"
        "SUPER,Tab,togglejump"
        "SUPER,Q,killclient"
        "SUPER,F,togglemaximizescreen"
        "SUPER+SHIFT,f,togglefullscreen"
        "SUPER,Z,togglefloating"
        
        #Window navigation
        "SUPER,A,focusdir,left"
        "SUPER,D,focusdir,right"
        "SUPER,S,focusdir,down"
        "SUPER,W,focusdir,up"

        "SUPER+SHIFT,A,scroller_stack,left"
        "SUPER+SHIFT,D,scroller_stack,right"
        "SUPER+SHIFT,S,exchange_client,down"
        "SUPER+SHIFT,W,exchange_client,up"

        "SUPER+SHIFT,1,tag,1"
        "SUPER+SHIFT,2,tag,2"
        "SUPER+SHIFT,3,tag,3"
        "SUPER+SHIFT,4,tag,4"
        "SUPER+SHIFT,5,tag,5"
        "SUPER+SHIFT,6,tag,6"
        "SUPER+SHIFT,7,tag,7"
        "SUPER+SHIFT,8,tag,8"
        "SUPER+SHIFT,9,tag,9"

        "SUPER,1,comboview,1"
        "SUPER,2,comboview,2"
        "SUPER,3,comboview,3"
        "SUPER,4,comboview,4"
        "SUPER,5,comboview,5"
        "SUPER,6,comboview,6"
        "SUPER,7,comboview,7"
        "SUPER,8,comboview,8"
        "SUPER,9,comboview,9"

        # FN Shortcuts
        "NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_SINK@ 2%+"
        "NONE,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_SINK@ 2%-"
        "SHIFT,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_SOURCE@ 2%+"
        "SHIFT,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_SOURCE@ 2%-"
        "NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_SINK@ toggle"
        "SHIFT,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_SOURCE@ toggle"

      ];

      mousebind = [
        "SUPER,btn_left,moveresize,curmove"
        "SUPER,btn_right,moveresize,curresize"
      ];

    };

    extraConfig = ''
      env=TZDIR,/etc/zoneinfo
      env=GTK_IM_MODULE,fcitx
      env=QT_IM_MODULE,wayland;fcitx
      env=XMODIFIERS,@im=fcitx
      env=SDL_IM_MODULE,fcitx
      env=GLFW_IM_MODULE,ibus
    '';
  };
}