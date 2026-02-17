{ pkgs, ... }:

{

  programs.fish = {
    enable = true;

    shellAliases = {
      hmodules = "nvim ~/nixos-dotfiles/modules/home/";
      packages = "nvim ~/nixos-dotfiles/modules/home/packages.nix";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos";
    };

    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      zmodload zsh/zprof

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

      zprof
    '';
  };

}

