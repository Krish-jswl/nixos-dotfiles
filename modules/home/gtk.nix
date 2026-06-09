{ config, pkgs, ... }:

let
  tomorrow-night-gtk =
    pkgs.callPackage ./pkgs/tomorrow-night-gtk.nix {};
in

{
  gtk = {
    enable = true;

    gtk4.theme = null;

    theme = {
        name = "tomorrow-night";
        package = tomorrow-night-gtk;
    };

    iconTheme = {
      name = "Papirus-Dark";
      # package = pkgs.papirus-icon-theme;
      package = pkgs.papirus-icon-theme.override {
        color = "green";
      };
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
  };
}
