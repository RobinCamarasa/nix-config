{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [ ./bundles/auth.nix ];

  bd.auth.enable = lib.mkDefault true;
}
