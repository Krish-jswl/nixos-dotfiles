{ pkgs, ... }:

{
  # programs.emacs = {
  #   enable = true;
  #   package = pkgs.emacs-pgtk;
  # };
  #
  # programs.direnv = {
  #   enable = true;
  #   nix-direnv.enable = true;
  # }; 

  home.packages = with pkgs; [
    # C/C++ tooling
    gcc
    clang-tools
    cmake
    gnumake
    pkg-config
    bear

    # General development
    ripgrep
    fzf
    go
    python3
    rustup

    # Archive utilities
    unzip
    gnutar
    gzip

  ];

  programs.tmux = {
    enable = true;
    extraConfig = ''
      # Reload config
      unbind r
      bind r source-file ~/.tmux.conf \; display-message "Config reloaded"

      # Prefix
      unbind C-b
      set -g prefix C-s
      bind C-s send-prefix

      # True color
      set -g default-terminal "tmux-256color"
      set -as terminal-features ",*:RGB"

      # Responsive ESC
      set -sg escape-time 10

      # Mouse support
      set -g mouse on

      # Clipboard integration
      set -s set-clipboard on

      # Better scrollback
      set -g history-limit 100000

      # Vi keys in copy mode
      setw -g mode-keys vi

      # Renumber windows
      set -g renumber-windows on

      # Status bar
      set -g status-position bottom

      # Pane navigation (prefix + hjkl)
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Split in current directory
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      unbind '"'
      unbind %

      # Start windows in current directory
      bind c new-window -c "#{pane_current_path}"

      # Focus events (helps Neovim)
      set -g focus-events on

      # Better terminal key handling
      set -g xterm-keys on
    '';
  };

}


