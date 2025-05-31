{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    ../homebrewed-features/inkscape.nix
    ../homebrewed-features/gimp.nix
  ];
  options = {
    bd.design.enable = lib.mkEnableOption "enables design";
  };
  config = {
    ft.inkscape.enable = lib.mkDefault config.bd.design.enable;
    ft.gimp.enable = lib.mkDefault config.bd.design.enable;
  };
}
