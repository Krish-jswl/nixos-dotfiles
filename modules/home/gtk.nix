{ pkgs, ... }:

{
  gtk = {
    enable = true;

    gtk4 = {
      theme = {
        name = "Adwaita";
        package = pkgs.gnome-themes-extra;
      };
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    theme = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
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
