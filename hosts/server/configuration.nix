{ pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
    ./locale.nix
  ];

  #System features
  system.features.mango        = false;
  system.features.plasma       = true;
  system.features.ly           = true;
  system.features.virt-manager = false;
  system.features.docker       = false;
  system.features.nextcloud    = true;
  system.features.bluetooth    = false;
  system.features.hamachi      = false;
  system.features.millennium   = false;
  system.features.flatpak      = false;
  system.features.appimage     = false;

  #Nix features
  nix.settings.experimental-features = [ "nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  #Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.consoleLogLevel = 3;
  boot.kernelParams = [
    "quiet"
    "splash"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
  ];
  boot.plymouth = {
    enable = true;
    theme = "lone";
    themePackages = with pkgs; [
      (adi1090x-plymouth-themes.override {
        selected_themes = [ "lone" ];
      })
    ];
  };

  #HostName
  networking.hostName = "lostserver";

  # Server Power & Sleep Management
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchDocked = "ignore";

  # Security & SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
    };
  };
  services.fail2ban.enable = true;

  # Tailscale for secure remote mesh networking
  services.tailscale.enable = true;

  # Firewall
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedTCPPorts = [ 22 80 443 ];
  };

  # Hardware health monitoring
  services.smartd.enable = true;

  #Users
  users.users.lost = {
    isNormalUser = true;
    description = "Lost";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "libvirtd"
      "camera"
      "MPD"
    ];
  };

  #Homemanager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # Preserve pre-existing, manually managed dotfiles during first takeover.
    backupFileExtension = "home-manager-backup";
    extraSpecialArgs = { inherit inputs; };
    users.lost = import ../../modules/home/server.nix;
  };

  # Do not change after installation.
  system.stateVersion = "26.05";
}