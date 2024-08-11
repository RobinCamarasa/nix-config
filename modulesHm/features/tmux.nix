{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    ft.tmux.enable = lib.mkEnableOption "enables tmux";
  };
  config = {
    programs.tmux = lib.mkIf config.ft.tmux.enable {
      enable = true;
      shortcut = "j";
      keyMode = "vi";
      disableConfirmationPrompt = true;
      extraConfig = ''
        set-option -g default-terminal "screen-256color"
        set -s escape-time 0
        set-option -g default-command "test -f $(pwd)/.tmuxrc && bash --rcfile $(pwd)/.tmuxrc || bash"
        set-option -g allow-rename off
        bind-key -n M-l next-window
        bind-key -n M-h previous-window
        bind m split-window ts
        bind-key X if-shell '[ $(tmux list-sessions | wc -l) -ne 1 ]' \
                      "run-shell 'tmux switch-client -n \\\; kill-session -t \"#S\"'" \
                      "run-shell 'tmux kill-session -t \"#S\"'"

        # Style
        set-option -g status-style bg="#088585"
      '';
    };
    programs.bash.shellAliases = lib.mkIf config.ft.tmux.enable { tmux = "tmux -u"; };
  };
}
