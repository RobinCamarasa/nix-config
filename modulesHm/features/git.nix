{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    ft.git.enable = lib.mkEnableOption "enables git";
    ft.git.userEmail = lib.mkOption {
      default = "robin.camarasa@pm.me";
      type = pkgs.lib.types.string;
      description = "set git userEmail";
    };
    ft.git.userName = lib.mkOption {
      default = "RobinCamarasa";
      type = pkgs.lib.types.string;
      description = "set git userName";
    };
  };
  config = {
    programs.git = lib.mkIf config.ft.git.enable {
      enable = true;
      userEmail = config.ft.git.userEmail;
      userName = config.ft.git.userName;
    };
  };
}
