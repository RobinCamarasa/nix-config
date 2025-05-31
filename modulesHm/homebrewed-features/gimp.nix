{
  pkgs,
  lib,
  config,
  ...
}:

{
  options = {
    ft.gimp.enable = lib.mkEnableOption "Enable gimp";
  };

  config = {
    home.packages = lib.mkIf config.ft.gimp.enable [
      pkgs.gimp
    ];
  };
}
