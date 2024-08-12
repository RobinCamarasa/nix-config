{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  options = {
    ft.kitty.enable = lib.mkEnableOption "enables kitty";
  };
  config = {
    programs.kitty = lib.mkIf config.ft.kitty.enable {
      enable = true;
      theme = "Tokyo Night";
      settings = {
        enable_audio_bell = false;
        allow_remote_control = "yes";
        hide_window_decorations = "yes";
      };
      font = {
        size = 14;
        name = "Inconsolata Nerd Font";
      };
    };
  };
}
