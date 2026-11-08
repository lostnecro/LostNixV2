# Módulo NixOS para o adaptador Wavlink / Silicon Motion SM768 (090c:0768)
# Importe em configuration.nix:  imports = [ ./smi-usbdisplay-module.nix ];
{ config, pkgs, ... }:

let
  evdi = config.boot.kernelPackages.evdi;
  smi = pkgs.callPackage ./smi-usbdisplay.nix { inherit evdi; };
in
{
  nixpkgs.config.allowUnfree = true;

  # módulo de kernel EVDI (o mesmo usado pelo DisplayLink)
  boot.extraModulePackages = [ evdi ];
  boot.kernelModules = [ "evdi" ];

  environment.systemPackages = [ smi ];

  # serviço que faz o adaptador funcionar
  systemd.services.smiusbdisplay = {
    description = "Silicon Motion USB Display Manager";
    after = [ "systemd-udevd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${smi}/bin/SMIUSBDisplayManager";
      StateDirectory = "smiusbdisplay";
      WorkingDirectory = "/var/lib/smiusbdisplay";
      Restart = "always";
      RestartSec = 5;
    };
  };

  # X11: mantém modesetting para os monitores EVDI aparecerem
  services.xserver.videoDrivers = [ "modesetting" ];
}
