{ pkgs, ... }:

{
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
    extensions = with pkgs; [ gh-dash ];
  };

  programs.git = {
    enable = true;
    settings = {
      credential.helper = "${pkgs.gh}/bin/gh auth git-credential";
      include.path = "~/.config/git/.gitconfig.local";
    };
  };
}