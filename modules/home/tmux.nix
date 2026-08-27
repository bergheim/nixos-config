{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    shell = "${pkgs.zsh}/bin/zsh";
    prefix = "C-Space";
    keyMode = "vi";
    mouse = true;
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 10000;
    clock24 = true;
    aggressiveResize = true;
    focusEvents = true;
    reverseSplit = true;
    sensibleOnTop = true;
    extraConfig = ''
      set -sg terminal-overrides ",*:RGB"
      set -s extended-keys on
      set -g extended-keys-format csi-u
      set -as terminal-features ',*:clipboard:sixel:extkeys'
      set -g allow-passthrough all
      set -g set-clipboard on

      bind Space send-prefix
      bind-key C-Space last-window

      unbind-key -T copy-mode-vi v
      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi C-v send -X rectangle-toggle
      bind-key -T copy-mode-vi y send -X copy-selection
      bind -T copy-mode-vi Enter send-keys -X copy-selection-and-cancel
      bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-selection

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D
      bind -n M-p previous-window
      bind -n M-n next-window
      bind -n M-J resize-pane -D 5
      bind -n M-K resize-pane -U 5
      bind -n M-H resize-pane -L 5
      bind -n M-L resize-pane -R 5

      setw -g automatic-rename on
      set -g set-titles on
      set -g set-titles-string '#h | #S | #W'
      set -g visual-activity off
      setw -g monitor-activity off

      bind r source-file ~/.config/tmux/tmux.conf

      set -g status-interval 30
      set -g status-justify centre
      set -g status-left-length 30
      set -g status-left "#{?client_prefix,#[reverse],} #h  #S #[noreverse]"
      set -g status-right "#{?#{>=:#{client_width},100},  %d %b   %H:%M ,}"
      set -g status-style default
      set -g status-left-style 'fg=green bold'
      setw -g window-status-current-style 'fg=green bg=default reverse bold'
      set -g pane-active-border-style 'fg=green'
      set -g pane-border-style 'fg=brightblack'
      set -g message-style 'fg=yellow bg=default reverse'
      set -g mode-style 'fg=green bg=default reverse'
    '';
  };
}
