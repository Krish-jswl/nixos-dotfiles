{ ... }:

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
      # File manager
      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];

      # Browser
      "text/html" = [ "librewolf.desktop" ];
      "application/xhtml+xml" = [ "librewolf.desktop" ];
      "x-scheme-handler/http" = [ "librewolf.desktop" ];
      "x-scheme-handler/https" = [ "librewolf.desktop" ];
      "x-scheme-handler/about" = [ "librewolf.desktop" ];
      "x-scheme-handler/unknown" = [ "librewolf.desktop" ];

      # PDF
      "application/pdf" = [ "sioyek.desktop" ];
    };
  };
}
