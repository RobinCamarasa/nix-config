{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [ ../features/pass/pass.nix ];
  options = {
    bd.auth.enable = lib.mkEnableOption "enables auth";
  };
  config = {
    ft.pass.enable = lib.mkDefault config.bd.auth.enable;
  };
}
