{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    ft.bash.enable = lib.mkEnableOption "enables bash";
    ft.bash.TSPATH = lib.mkOption {
      default = "/etc/nixos";
      type = pkgs.lib.types.string;
      description = "set TSPATH variable";
    };
  };
  config = {
    programs.bash = lib.mkIf config.ft.bash.enable {
      enable = true;
      enableCompletion = true;
      bashrcExtra = ''
        export PATH="$PATH:./"
        clear
        neofetch
        export TSPATH="${config.ft.bash.TSPATH}"
      '';
      shellAliases = {
        svi = "sudo -E -s nvim";
      };
    };
  };
}