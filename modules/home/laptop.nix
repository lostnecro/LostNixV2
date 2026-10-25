{ pkgs,... }:

{
  imports = [
    ./flatpak.nix
    ./apps-config/vim.nix
    ./apps-config/stream.nix
    ./apps-config/git.nix
    ./apps-config/winapps.nix
  ];

  # User settings
  home.username = "lost";
  home.homeDirectory = "/home/lost";

  # Home-manager
  programs.home-manager.enable = true;

  # Shell
  #Default shell
  programs.bash = {
    enable = true;
    initExtra = "fastfetch";
  };

  #Shell aliases
  home.shellAliases = {
    #LSW Aliases
    lsw-on = "docker compose --file ~/.config/winapps/compose.yaml start";
    lsw-off = "docker compose --file ~/.config/winapps/compose.yaml stop";
    lsw-restart = "docker compose --file ~/.config/winapps/compose.yaml restart";
    lsw-kill = "docker compose --file ~/.config/winapps/compose.yaml kill";
    cat = "bat";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    ANI_CLI_PLAYER = "mpv";
  };

  home.sessionPath = [
    "~/.local/bin"
  ];


  # User packages
  home.packages = with pkgs; [

    ## Utilities
    brightnessctl
    wl-clipboard
    wev
    xwayland-satellite
    bluez
    p7z
    unzip
    unrar
    ocs-url
    bluetui
    dialog
    iprout2
    libnotify
    netcat-openbsd
    networkmanagerapplet
    playerctl
    yt-dlp
    yazi
    nix-search-cli
    distrobox
    scrcpy
    nix-direnv
    pavucontrol

    ## WM
    awww
    rofi
    nwg-look
    satty
    grim
    slurp
    waybar
    wl-gammactl
    dunst

    ## Code
    bat
    python314
    git
    kitty
    vscode
    docker-compose
    ghostty
    jdk
    go
    gcc
    helix

    ## Privacy
    keepassxc
    proton-vpn

    ## Games
    hydralauncher
    protonup-qt
    wineWow64Packages.waylandFull
    winetricks
    heroic
    equibop
    prismlauncher

    ## Entertain  
    mpv
    vlc
    ani-cli

    ## Creation
    gimp
    inkscape
    blender
    kdePackages.kdenlive

    ## Stream
    obs-studio-plugins.obs-vkcapture
    obs-studio-plugins.obs-multi-rtmp
    obs-cmd
    obs-cli

    ## Study
    obsidian
    anki
    kdePackages.kiten
    tagainijisho
    kanarenshu
  ];

  home.stateVersion = "25.11";
}