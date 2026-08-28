{ pkgs, ... }:

let
  vagueGtk = import ../pkgs/vague-gtk.nix { inherit pkgs; };
in

{
  gtk = {
    enable = true;

    theme = {
      name = "Vague";
      package = vagueGtk;
    };

    gtk4.theme = {
      name = "Vague";
      package = vagueGtk;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Amber";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
  };
}
