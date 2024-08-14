{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  options = {
    ft.ncspot.enable = lib.mkEnableOption "enables ncspot";
  };
  config = {
    programs.ncspot = lib.mkIf config.ft.ncspot.enable { enable = true; };
  };
}
