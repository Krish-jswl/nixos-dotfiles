{ ... }:
{
  programs.tmux = {
    enable = true;

    prefix = "C-s";
    terminal = "tmux-256color";

    mouse = true;
    historyLimit = 100000;
    keyMode = "vi";
    escapeTime = 10;
    focusEvents = true;

    extraConfig = ''
      unbind C-b
      bind C-s send-prefix

      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      set -as terminal-features ",*:RGB"
      set -g xterm-keys on
      set -g renumber-windows on
      set -g status-position bottom
    '';
  };
}
