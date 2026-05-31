{ pkgs, ... }:

{

  programs.zsh = {
    enable = true;

    shellAliases = {
      hmodules = "nvim ~/nixos-dotfiles/modules/home/";
      packages = "nvim ~/nixos-dotfiles/modules/home/packages.nix";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos";
    };

    history = {
      size = 10000;
      save = 10000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      share = true;
    };

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    initContent = ''
      # Completion
      autoload -Uz compinit
      compinit

      zstyle ':completion:*' menu select
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path ~/.zsh/cache

      WORDCHARS='*?_[]~=&;!#$%^(){}<>'

      # Ctrl+Backspace / Ctrl+W
      bindkey '^H' backward-kill-word
      bindkey '^W' backward-kill-word

      # Prompt
      PROMPT='%F{cyan}%n@%m%f %F{blue}%~%f %# '

    '';
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

