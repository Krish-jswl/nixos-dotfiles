{ pkgs, ... }:

{
  programs.bash = {
	enable = true;
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    shellAliases = {
      hmodules = "nvim ~/nixos-dotfiles/modules/home/";
      packages = "nvim ~/nixos-dotfiles/modules/home/packages.nix";

      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos";
    };


    initContent = ''
      bindkey '^H' backward-kill-word
      WORDCHARS=''${WORDCHARS//[\/\-#]/}


      # ssh agent
      if ! pgrep -u "$USER" ssh-agent > /dev/null; then
        eval "$(ssh-agent -s)"
      fi

      ssh-add ~/.ssh/id_ed25519 2>/dev/null

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

}

