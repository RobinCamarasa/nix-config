{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  options = {
    ft.zathura.enable = lib.mkEnableOption "enables zathura";
  };
  config = {
    programs.zathura = lib.mkIf config.ft.zathura.enable { enable = true; };
  };
}
