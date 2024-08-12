{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    ../features/zathura.nix
    ../features/gnome.nix
    ../features/firefox.nix
    ../features/kitty.nix
  ];
  ft.zathura.enable = lib.mkDefault true;
  ft.gnome.enable = lib.mkDefault true;
  ft.firefox.enable = lib.mkDefault true;
  ft.kitty.enable = lib.mkDefault true;
}
