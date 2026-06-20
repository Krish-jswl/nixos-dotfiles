{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    loginExtra = ''
      if [[ -z "$WAYLAND_DISPLAY" && "$XDG_VTNR" == "1" ]]; then
        exec dbus-run-session mango
      fi
    '';

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
      compinit -C

      zstyle ':completion:*' menu select
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path ~/.zsh/cache

      WORDCHARS='*?_[]~=&;!#$%^(){}<>'

      # Ctrl+Backspace / Ctrl+W
      bindkey '^H' backward-kill-word
      bindkey '^W' backward-kill-word

      # Prompt
      setopt PROMPT_SUBST

      nix_prompt() {
        # Custom flake/dev shell name
        if [[ -n "$DEVSHELL_NAME" ]]; then
          echo "%F{magenta}[󱄅 $DEVSHELL_NAME]%f "
          return
        fi

        # Generic nix shell / nix develop
        if [[ -n "$IN_NIX_SHELL" ]]; then
          case "$IN_NIX_SHELL" in
            pure)
              echo "%F{green}[󱄅 pure]%f "
              ;;
            impure)
              echo "%F{yellow}[󱄅 impure]%f "
              ;;
            *)
              echo "%F{blue}[󱄅 nix]%f "
              ;;
          esac
          return
        fi

        # direnv
        if [[ -n "$DIRENV_DIR" ]]; then
          echo "%F{cyan}[direnv]%f "
        fi
      }

      # key
      bindkey '^R' history-incremental-search-backward

      PROMPT='$(nix_prompt)%F{cyan}%n@%m%f %F{blue}%~%f %# '
      # Paths
      export PATH="/usr/local/bin:$PATH"

      # Env Var
      export EDITOR=nvim
      export VISUAL=nvim
      export TERM=alacritty
    '';
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      unbind r 
      bind r source-file ~/.tmux.conf

      set -g prefix C-s

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

}

