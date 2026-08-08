{ ... }:

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
      compinit -C

      # vim mode
      bindkey -v
      export KEYTIMEOUT=1

      zstyle ':completion:*' menu select
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path ~/.zsh/cache

      WORDCHARS='*?_[]~=&;!#$%^(){}<>'

      # Ctrl+Backspace / Ctrl+W
      bindkey '^H' backward-kill-word
      bindkey '^W' backward-kill-word
      bindkey -M viins '^?' backward-delete-char

      # --- Vim Mode Indicator Setup ---
      VIM_MODE="%F{blue}I%f" # Default to Insert

      function update_vim_mode() {
        if [[ $REGION_ACTIVE -ne 0 ]]; then
          VIM_MODE="%F{yellow}V%f"
        elif [[ $KEYMAP == vicmd ]]; then
          VIM_MODE="%F{green}N%f"
        else
          VIM_MODE="%F{blue}I%f"
        fi
        zle reset-prompt
      }

      function zle-keymap-select() { update_vim_mode }
      zle -N zle-keymap-select

      function zle-line-init() { update_vim_mode }
      zle -N zle-line-init

      # Wrap visual modes to trigger prompt update
      function custom-visual-mode() {
        zle visual-mode
        update_vim_mode
      }
      zle -N custom-visual-mode
      bindkey -M vicmd 'v' custom-visual-mode

      function custom-visual-line-mode() {
        zle visual-line-mode
        update_vim_mode
      }
      zle -N custom-visual-line-mode
      bindkey -M vicmd 'V' custom-visual-line-mode

      # Wrap escape to correctly catch exiting visual/insert modes
      function custom-vi-cmd-mode() {
        zle vi-cmd-mode
        update_vim_mode
      }
      zle -N custom-vi-cmd-mode
      bindkey -M viins '\e' custom-vi-cmd-mode
      bindkey -M vicmd '\e' custom-vi-cmd-mode
      # --------------------------------

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

      # Inject the Vim mode indicator into the prompt
      PROMPT='$(nix_prompt)[''${VIM_MODE}] %F{cyan}%n@%m%f %F{blue}%~%f %# '
      
      # Paths
      export PATH="/usr/local/bin:$PATH"
      export PATH="/home/krishj/go/bin:$PATH"

      # Env Var
      export EDITOR=nvim
      export VISUAL=nvim
      export TERM=xterm-kitty
    '';
  };
}
