{ config, pkgs, ... }:

let
  tomorrow-night-gtk =
    pkgs.callPackage ./pkgs/tomorrow-night-gtk.nix {};
in

{
  gtk = {
    enable = true;

    gtk4.theme = null;

    # theme = {
    #     name = "tomorrow-night";
    #     package = tomorrow-night-gtk;
    # };

    theme = {
      name = "catppuccin-mocha-lavender-standard+normal";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "lavender" ];
        size = "standard";
        tweaks = [ "normal" ];
        variant = "mocha";
      };
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme.override {
        color = "blue";
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
