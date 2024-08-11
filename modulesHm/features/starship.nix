{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    ft.starship.enable = lib.mkEnableOption "enables starship";
  };
  config = {
    programs.starship = {
      enable = config.ft.starship.enable;
    };
  };
}
