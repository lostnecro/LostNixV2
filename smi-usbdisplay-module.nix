# Módulo NixOS para o adaptador Wavlink / Silicon Motion SM768 (090c:0768)
# Importe em configuration.nix:  imports = [ ./smi-usbdisplay-module.nix ];
{ config, pkgs, ... }:

let
  # O SMIUSBDisplayManager chama evdi_open_attached_to(NULL), mas o libevdi
  # (>= 1.14) faz strlen(NULL) ali e dá segfault -> loop de crash/reconexão.
  evdi = config.boot.kernelPackages.evdi.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace library/evdi_lib.c --replace-fail \
        'evdi_open_attached_to_fixed(sysfs_parent_device, strlen(sysfs_parent_device))' \
        'evdi_open_attached_to_fixed(sysfs_parent_device, sysfs_parent_device ? strlen(sysfs_parent_device) : 0)'
    '';
  });
  smi = pkgs.callPackage ./smi-usbdisplay.nix { inherit evdi; };
in
{
  nixpkgs.config.allowUnfree = true;

  # módulo de kernel EVDI (o mesmo usado pelo DisplayLink)
  boot.extraModulePackages = [ evdi ];
  boot.kernelModules = [ "evdi" ];
  # NÃO usar initial_device_count: criar dispositivos EVDI no boot faz eles
  # pegarem card1..card4 antes da amdgpu, e o KWin (login/Plasma) fica
  # piscando/quebra. O SMIUSBDisplayManager cria o dispositivo sob demanda.

  environment.systemPackages = [ smi ];

  # O binário tem /opt/siliconmotion/ fixo no código (firmware, arquivos
  # temporários). Diretório real e gravável + links para o firmware.
  systemd.tmpfiles.rules = [ "d /opt/siliconmotion 0755 root root -" ]
    ++ map (f: "L+ /opt/siliconmotion/${f} - - - - ${smi}/lib/smiusbdisplay/${f}") [
      "USBDisplay.bin"
      "USBDisplay770.bin"
      "Bootloader0.bin"
      "Bootloader1.bin"
      "firmware0.bin"
    ];

  # serviço que faz o adaptador funcionar
  systemd.services.smiusbdisplay = {
    description = "Silicon Motion USB Display Manager";
    # como o serviço oficial: só depois do display manager, para o KWin já
    # ter pego a GPU real quando o dispositivo EVDI aparecer
    after = [ "systemd-udevd.service" "systemd-tmpfiles-setup.service" "display-manager.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${smi}/bin/SMIUSBDisplayManager";
      WorkingDirectory = "/opt/siliconmotion";
      Restart = "always";
      RestartSec = 5;
    };
  };

  # X11: mantém modesetting para os monitores EVDI aparecerem
  services.xserver.videoDrivers = [ "modesetting" ];
}
