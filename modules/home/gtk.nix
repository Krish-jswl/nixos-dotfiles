{ pkgs, ... }:

let
  gruvboxSoft =
    pkgs.gruvbox-gtk-theme.overrideAttrs (old: {
      installPhase = ''
        mkdir -p $out/share/themes
        cd themes
        bash install.sh \
          -d $out/share/themes \
          -c dark \
          -t default \
          --tweaks soft
      '';
    });
in

{
  gtk = {
    enable = true;

    theme = {
      name = "gruvbox-gtk-theme-0-unstable-2025-10-23-Dark-Soft";
      package = gruvboxSoft;
    };

    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
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

