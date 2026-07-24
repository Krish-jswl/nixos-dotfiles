{ pkgs, ... }:

{
  gtk = {
    enable = true;

    theme = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
    };

    gtk4 = {
      theme = {
        name = "Adwaita";
        package = pkgs.gnome-themes-extra;
      };

      extraCss = ''
        @define-color accent_bg_color #d9bb80;
        @define-color accent_fg_color #2A2426;

        @define-color window_bg_color #2A2426;
        @define-color window_fg_color #e6d6ac;

        @define-color headerbar_bg_color #312b2d;
        @define-color headerbar_fg_color #e6d6ac;

        @define-color sidebar_bg_color #242021;
        @define-color sidebar_fg_color #e6d6ac;

        window {
          background: @window_bg_color;
          color: @window_fg_color;
        }

        headerbar {
          background: @headerbar_bg_color;
          color: @headerbar_fg_color;
        }

        .navigation-sidebar,
        .sidebar {
          background: @sidebar_bg_color;
          color: @sidebar_fg_color;
        }

        row:selected {
          background: #444444;
          color: @window_fg_color;
        }

        button {
          background: #353032;
          color: @window_fg_color;
          border-radius: 8px;
        }

        button:hover {
          background: #3b3537;
        }

        entry,
        searchbar entry {
          background: #312b2d;
          color: @window_fg_color;
          border-radius: 8px;
        }

        scrollbar slider {
          background: #444444;
        }
      '';
    };

    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };

      extraCss = ''
        @define-color theme_bg_color #2A2426;
        @define-color theme_fg_color #e6d6ac;

        @define-color theme_selected_bg_color #444444;
        @define-color theme_selected_fg_color #e6d6ac;

        @define-color sidebar_bg_color #242021;
        @define-color sidebar_fg_color #e6d6ac;

        window {
          background: @theme_bg_color;
          color: @theme_fg_color;
        }

        headerbar {
          background: #312b2d;
          color: @theme_fg_color;
        }

        .sidebar,
        placessidebar,
        .navigation-sidebar {
          background: @sidebar_bg_color;
          color: @sidebar_fg_color;
        }

        .sidebar row,
        placessidebar row,
        .navigation-sidebar row {
          background: transparent;
          color: @sidebar_fg_color;
        }

        .sidebar row:selected,
        placessidebar row:selected,
        .navigation-sidebar row:selected {
          background: #444444;
          color: @theme_fg_color;
        }

        button {
          background: #353032;
          color: @theme_fg_color;
          border-radius: 8px;
        }

        button:hover {
          background: #3b3537;
        }

        entry,
        .search-entry {
          background: #312b2d;
          color: @theme_fg_color;
          border-radius: 8px;
        }

        treeview.view:selected {
          background: #444444;
          color: @theme_fg_color;
        }

        scrollbar slider {
          background: #444444;
        }
      '';
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme.override {
        color = "green";
      };
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
