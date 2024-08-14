{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  options = {
    ft.atuin.enable = lib.mkEnableOption "enables atuin";
  };
  config = {
    programs.atuin = lib.mkIf config.ft.atuin.enable {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
