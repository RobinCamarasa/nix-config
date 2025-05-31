{
  pkgs,
  lib,
  config,
  ...
}:

{
  options = {
    ft.inkscape.enable = lib.mkEnableOption "Enable inkscape";
  };

  config = {
    home.packages = lib.mkIf config.ft.inkscape.enable [
      pkgs.inkscape-with-extensions
    ];
  };
}
