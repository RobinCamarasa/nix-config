{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    ft.tmux.enable = lib.mkEnableOption "enables tmux";
    ft.tmux.main = lib.mkEnableOption "enables main tmux";
  };
  config = {
    home.packages = lib.mkIf config.ft.tmux.enable [
      (pkgs.writers.writeBashBin "ts" { } (builtins.readFile ./ts.sh))
    ];
    programs.tmux = lib.mkIf config.ft.tmux.enable {
      enable = true;
      shortcut = lib.mkIf config.ft.tmux.main "j";
      keyMode = "vi";
      disableConfirmationPrompt = true;
      extraConfig =
        ''
          set-option -g default-terminal "screen-256color"
          set-option -g allow-rename off
          set -s escape-time 0
          bind m split-window ts
          bind-key X if-shell '[ $(tmux list-sessions | wc -l) -ne 1 ]' \
                        "run-shell 'tmux switch-client -n \\\; kill-session -t \"#S\"'" \
                        "run-shell 'tmux kill-session -t \"#S\"'"
        ''
        + (
          if config.ft.tmux.main then
            ''
              bind-key -n M-l next-window
              bind-key -n M-h previous-window
              bind -r h select-pane -L
              bind -r j select-pane -D
              bind -r k select-pane -U
              bind -r l select-pane -R
              set-option -g status-style bg="#088585"
            ''
          else
            ''''
        );
    };
    programs.bash.shellAliases = lib.mkIf config.ft.tmux.enable { tmux = "tmux -u"; };
  };
}
