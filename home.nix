{ config, pkgs, ... }:

{
  home.username = "krishj";
  home.homeDirectory = "/home/krishj";
  home.stateVersion = "25.05";

  imports = [
    ./modules/home/default.nix
    ./modules/nixvim/default.nix
  ];

  xdg.userDirs.setSessionVariables = true;

  home.sessionVariables = {
    TERMINAL = "kitty";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
    };
  };
}
