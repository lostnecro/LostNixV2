{ pkgs,... }:

{
  imports = [
    ./apps-config/vim.nix
    ./apps-config/git.nix
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
    cat = "bat";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.sessionPath = [
    "~/.local/bin"
  ];

  # User packages
  home.packages = with pkgs; [];

  home.stateVersion = "25.11";
}