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
    };
in

{
	home.username = "ternoid";
	home.homeDirectory = "/home/ternoid";
	programs.git.enable = true;
	home.stateVersion = "25.05";


	programs.bash = {
		enable = true;
	};

    programs.fish = {
        enable = true;
        interactiveShellInit = ''
            set -g fish_greeting
        '';
    };

    programs.fish.shellAliases = {
        nrebuild  = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#ternix";
    };

    programs.tmux = {
        enable = true;
        extraConfig = "
            unbind r 
            bind r source-file ~/.tmux.conf

            set -g prefix C-s

            set -sg escape-time 0

            set -g mouse on 

            bind-key h select-pane -L
            bind-key j select-pane -D
            bind-key k select-pane -U
            bind-key l select-pane -R

            set-option -g status-position bottom
        ";
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
            name = "Nordic";
            package = pkgs.nordic;
        };

        iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.papirus-icon-theme;
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
	];

}
