{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [ ../features/ncspot.nix ];
  ft.ncspot.enable = lib.mkDefault true;
}
