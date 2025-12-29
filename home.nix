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

    xdg.configFile = builtins.mapAttrs 
        (name: subpath: {
            source = create_symlink "${dotfiles}/${subpath}";
            recursive = true;
    })
    configs;


    gtk = {
        enable = true;

        theme = {
            name = "catppuccin-mocha-blue-standard";
            package = (pkgs.catppuccin-gtk.override {
                accents = [ "blue" ];
                size = "standard";
                variant = "mocha";
            });
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
        unzip
        gnutar
        gzip
        neovim
        fzf
        qbittorrent
        vlc
        go
	];

}
