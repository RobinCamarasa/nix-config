{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    ft.direnv.enable = lib.mkEnableOption "enables direnv";
  };
  config = {
    programs.direnv = lib.mkIf config.ft.direnv.enable {
      enable = config.ft.direnv.enable;
      enableBashIntegration = true;
    };
  };
}
