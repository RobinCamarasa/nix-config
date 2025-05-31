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
    ../homebrewed-features/inkscape.nix
    ../features/kitty.nix
  ];
  options = {
    bd.design.enable = lib.mkEnableOption "enables design";
  };
  config = {
    ft.inkscape.enable = lib.mkDefault config.bd.design.enable;
  };
}
