{ config, pkgs, lib, ... }:

let
  grep = pkgs.gnugrep;
  flatpakCmd = "${pkgs.flatpak}/bin/flatpak";
  notifyCmd = "${pkgs.libnotify}/bin/notify-send";
  
  desiredFlatpaks = [
    "org.onlyoffice.desktopeditors"
    "app.zen_browser.zen"
    "it.mijorus.gearlever"
    "org.libretro.RetroArch"
    "rocks.shy.VacuumTube"
    "io.github.seinedkoda.kisel"
  ];
in {
  home.activation.manageFlatpaks = config.lib.dag.entryAfter ["writeBoundary"] ''
    (
      echo "Iniciando gerenciamento de Flatpaks em segundo plano..."
      ${notifyCmd} -u low -i system-software-update -t 1000 "Flatpak Manager" "Iniciando a sincronização dos seus Flatpaks..." 2>/dev/null || true
      
      # 1. Garante o repositório Flathub
      ${flatpakCmd} remote-add --user --if-not-exists flathub \
        https://dl.flathub.org/repo/flathub.flatpakrepo

      # 2. Pega os instalados no escopo do usuário
      installedFlatpaks=$(${flatpakCmd} list --user --app --columns=application)

      # 3. Remove os indesejados
      if [ -n "$installedFlatpaks" ]; then
        for installed in $installedFlatpaks; do
          if ! echo -e "${lib.concatStringsSep "\\n" desiredFlatpaks}" | ${grep}/bin/grep -qx "$installed"; then
            echo "Removendo $installed..."
            ${flatpakCmd} uninstall --user -y --noninteractive "$installed"
          fi
        done
      fi

      # 4. Instala os desejados
      for app in ${lib.concatStringsSep " " desiredFlatpaks}; do
        ${notifyCmd} -u low -i package-x-generic -t 1000 "Flatpak Manager" "Verificando/Instalando: $app" 2>/dev/null || true
        ${flatpakCmd} install --user -y flathub "$app"
      done

      # 5. Limpa e atualiza
      ${flatpakCmd} uninstall --user --unused -y
      ${flatpakCmd} update --user -y
    ) > "${config.home.homeDirectory}/.flatpak-script.log" 2>&1 &
  '';
}