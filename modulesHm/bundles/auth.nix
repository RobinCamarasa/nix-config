{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [ ../features/pass/pass.nix ];
  ft.pass.enable = lib.mkDefault true;
}
