{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    ./bundles/auth.nix
    ./bundles/gui.nix
    ./bundles/dev.nix
    ./bundles/terminal.nix
  ];

  bd.auth.enable = lib.mkDefault true;
  bd.dev.enable = lib.mkDefault true;
  bd.gui.enable = lib.mkDefault true;
  bd.terminal.enable = lib.mkDefault true;
}
