{ pkgs, ... }:

{
  #TimeZona
  time.timeZone = "America/Sao_Paulo";
  services.timesyncd.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  i18n.supportedLocales = [
    "all"
  ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      #fcitx5-mozc
      fcitx5-gtk
      kdePackages.fcitx5-qt
      kdePackages.fcitx5-chinese-addons
      fcitx5-fluent
      fcitx5-mellow-themes
      fcitx5-inflex-themes
    ];
  };

  # Configure console keymap
  console.keyMap = "us-acentos";
}
