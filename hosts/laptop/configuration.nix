{}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  #Nix features
  nix.settings.experimental-features = [ "nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  #Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
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
  networking.hostName = "lostnix";

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
    users.lost = import ../../modules/home/laptop.nix;
  };

  # Do not change after installation.
  system.stateVersion = "26.05";
}
