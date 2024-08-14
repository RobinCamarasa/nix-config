{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  options = {
    ft.zoxide.enable = lib.mkEnableOption "enables zoxide";
  };
  config = {
    programs.zoxide = lib.mkIf config.ft.zoxide.enable {
      enable = true;
      enableBashIntegration = true;
      options = [ "--cmd cd" ];
    };
  };
}
