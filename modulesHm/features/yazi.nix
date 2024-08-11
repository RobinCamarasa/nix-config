{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    ft.yazi.enable = lib.mkEnableOption "enables yazi";
  };
  config = lib.mkIf config.ft.yazi.enable {
    programs.yazi = {
      enable = true;
      enableBashIntegration = true;
      shellWrapperName = "yy";
    };
  };
}
