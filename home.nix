{ config, pkgs, ... }:

let
    dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
    create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
    configs = {
        hypr = "hypr";
        nvim = "nvim";
        foot = "foot";
        wofi = "wofi";
        waybar = "waybar";
        zathura = "zathura";
        mako = "mako";
    };
in

{
	home.username = "krishj";
	home.homeDirectory = "/home/krishj";
	home.stateVersion = "25.05";


	programs.bash = {
		enable = true;
	};

    programs.zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;

      initContent = ''
        bindkey '^H' backward-kill-word
        WORDCHARS=''${WORDCHARS//[\/\-#]/}
      '';
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.tmux = {
        enable = true;
        extraConfig = ''
            unbind r 
            bind r source-file ~/.tmux.conf

            set -g prefix C-s

            set -g default-terminal "$TERM"
            set -ag terminal-overrides ",$TERM:Tc"


            set -sg escape-time 0

            set -g mouse on 

            bind-key h select-pane -L
            bind-key j select-pane -D
            bind-key k select-pane -U
            bind-key l select-pane -R

            set-option -g status-position bottom
        '';
    };

      programs.git = {
        enable = true;

        userName = "Krish-jswl";
        userEmail = "imkrishjaiswal05@gmail.com";

        extraConfig = {
          init.defaultBranch = "main";
          core.editor = "nvim";
          pull.rebase = true;
        };
      };


    xdg.configFile = builtins.mapAttrs 
        (name: subpath: {
            source = create_symlink "${dotfiles}/${subpath}";
            recursive = true;
    })
    configs;

    gtk = {
      enable = true;

      theme = {
        name = "Gruvbox-Dark";
        package = pkgs.gruvbox-gtk-theme;
      };

      iconTheme = {
        name = "Gruvbox-Plus-Dark";
        package = pkgs.gruvbox-plus-icons;
      };
      gtk3.extraConfig = {
        gtk-theme-variant = "soft";
      };

      gtk4.extraConfig = {
        gtk-theme-variant = "soft";
      };
    };

    home.pointerCursor = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 24;
        
        gtk.enable = true;
    };

	home.packages = with pkgs; [
        fastfetch
        htop
        brightnessctl
        wl-clipboard
        hyprpaper
        hyprlock
        hypridle
        waybar
        wofi
        grim
        slurp
        ripgrep
        nixpkgs-fmt
        nodejs
        gcc
        clang-tools
        glibc.dev
        zathura
        zathuraPkgs.zathura_pdf_mupdf
        unzip
        gnutar
        gzip
        neovim
        fzf
        qbittorrent
        vlc
        go
        gopls
        obsidian
        obs-studio
        imv
        gnumake
        pkg-config
        tomato-c
        syncthing
        mako
        libnotify
        nautilus
        ffmpegthumbnailer

	];

}
