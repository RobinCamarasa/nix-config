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
  options = {
    bd.gui.enable = lib.mkEnableOption "enables gui";
  };
  config = {
    ft.zathura.enable = lib.mkDefault config.bd.gui.enable;
    ft.gnome.enable = lib.mkDefault config.bd.gui.enable;
    ft.firefox.enable = lib.mkDefault config.bd.gui.enable;
    ft.kitty.enable = lib.mkDefault config.bd.gui.enable;
  };
}
