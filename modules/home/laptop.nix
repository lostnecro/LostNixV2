{ pkgs,... }:

{
  imports = [
    ./flatpak.nix
    ./apps-config/vim.nix
    ./apps-config/stream.nix
    ./apps-config/git.nix
    ./apps-config/winapps.nix
    ./apps-config/waybar.nix
    ./apps-config/mango.nix
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
    p7zip
    unzip
    unrar
    ocs-url
    bluetui
    dialog
    iproute2
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
    remmina
    nautilus

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
    vscode-fhs
    antigravity-ide-fhs
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

    ## Rice
    nerd-fonts.ubuntu
    hachimarupop
    inter-nerdfont
    whitesur-gtk-theme
    whitesur-icon-theme
    whitesur-cursors
    waypaper
    afterglow-cursors-recolored
    mint-cursor-themes
    graphite-cursors
    posy-cursors
    hackneyed
    bibata-cursors-translucent
    marwaita-icons
    gruvbox-plus-icons
    edukai
    wqy_zenhei
    eduli
    moeli

  ];

  home.stateVersion = "25.11";
}
