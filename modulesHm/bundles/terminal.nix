{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [ ../features/ncspot.nix ];
  options = {
    bd.terminal.enable = lib.mkEnableOption "enables terminal";
  };
  config = {
    ft.ncspot.enable = lib.mkDefault config.bd.terminal.enable;
  };
}
