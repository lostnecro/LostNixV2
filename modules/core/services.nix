{ config, lib, pkgs, inputs, ... }:

with lib;
{
  imports = [
    inputs.mangowm.nixosModules.mango
  ];

  # Options
  options.system.features = {
    mango         = mkEnableOption "Mango compositor";
    plasma        = mkEnableOption "Plasma DE";
    incant        = mkEnableOption "IcantDE";
    pantheon      = mkEnableOption "Pantheon DE";

    ly            = mkEnableOption "Ly Display Manager";

    virt-manager  = mkEnableOption "enable VirtManager";
    docker        = mkEnableOption "Enable docker";
    bluetooth     = mkEnableOption "Enable bluetooth";
    hamachi       = mkEnableOption "LogMeIn Hamachi";

    millennium    = mkEnableOption "Enable steam millennium";

    flatpak       = mkEnableOption "Suporte a Flatpak";
    appimage      = mkEnableOption "Suporte a AppImage via binfmt";
    nextcloud     = mkEnableOption "Nextcloud personal cloud service";
  };

  # Config
  config = mkMerge [
    # Always on
    {
      # Network
      networking.networkmanager.enable = true;

      # Graphic acceleration
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      # XORG
      services.xserver.enable = true;
      services.libinput.enable = true;
      programs.xwayland.enable = true;

      # Audio
      services.pipewire = {
        enable = true;
        pulse.enable = true;
        alsa.enable = true;
      };

      # Portal
      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gtk ];
      };


      # SSH
      services.openssh.enable = true;

      # Direnv
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      # Misc
      hardware.i2c.enable = true;
      services.udisks2.enable = true;
      services.gvfs.enable = true;
      security.rtkit.enable = true;
      fonts.enableDefaultPackages = true;

      # GC
      nix = {
        gc = {
          automatic = true;
          dates = [ "10:00" ];
          options = "--delete-older-than 3d";
        };
        settings.auto-optimise-store = true;
      };
    }

    # Options setup

    # Mangowm
    (mkIf config.system.features.mango {
      programs.mango.enable = true;
    })

    # Plasma
    (mkIf config.system.features.plasma {
      services.desktopManager.plasma6.enable = true;
      services.displayManager.plasma-login-manager.enable = true;
    })

    # IncantDE
    (mkIf config.system.features.incant (
      let
        incant = inputs.incant.packages.${pkgs.stdenv.hostPlatform.system}.default;
        # Adds it to the login screen's list of sessions.
        session = (pkgs.writeTextDir "share/wayland-sessions/incant.desktop" ''
          [Desktop Entry]
          Name=IncantDE
          Comment=Incantation Desktop
          Exec=${incant}/bin/incant-compositor
          Type=Application
          DesktopNames=IncantDE
        '').overrideAttrs (old: {
          passthru = (old.passthru or { }) // { providedSessions = [ "incant" ]; };
        });
      in
      {
        services.displayManager.sessionPackages = [ session ];
        environment.systemPackages = [ incant ];
      }
    ))


    #LY
    (mkIf config.system.features.ly {
      services.displayManager.ly.enable = true;
    })

    # VirtManager
    (mkIf config.system.features.virt-manager {
      programs.virt-manager.enable = true;
    })

    # Docker
    (mkIf config.system.features.docker {
      virtualisation.docker = {
        enable = true;
        daemon.settings = {
          "data-root" = "/home/lost/Projects/DockerRoot";
        };
      };
    })

    # Bluetooth
    (mkIf config.system.features.bluetooth {
      hardware.bluetooth.enable = true;
    })

    # Hamachi
    (mkIf config.system.features.hamachi {
      services.logmein-hamachi.enable = true;
      programs.haguichi.enable = true;
    })

    # Millennium
    (mkIf config.system.features.millennium {
      programs.steam = {
        enable = true;
        package = pkgs.millennium-steam;
      };
      programs.gamemode.enable = true;
    })

    # Flatpak
    (mkIf config.system.features.flatpak {
      services.flatpak.enable = true;
    })

    # Appimage
    (mkIf config.system.features.appimage {
      programs.appimage.enable = true;
      programs.appimage.binfmt = true;
    })

    # Nextcloud
    (mkIf config.system.features.nextcloud {
      services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud35;
        hostName = "localhost";
        config = {
          dbtype = "pgsql";
        };
        database.createLocally = true;
      };

      # Ensure default admin pass file exists so first-run doesn't crash
      systemd.tmpfiles.rules = [
        "f /etc/nextcloud-admin-pass 0600 nextcloud nextcloud - admin"
      ];

      networking.firewall.allowedTCPPorts = [ 80 443 ];
    })
  ];
}
