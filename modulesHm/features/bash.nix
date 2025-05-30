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
      type = pkgs.lib.types.str;
      description = "set TSPATH variable";
    };
  };
  config = {
    home.packages = lib.mkIf config.ft.bash.enable [ pkgs.neofetch ];
    programs.bash = lib.mkIf config.ft.bash.enable {
      enable = true;
      enableCompletion = true;
      bashrcExtra = ''
        export PATH="$HOME/.local/bin:$PATH:./"
        clear
        export TSPATH="${config.ft.bash.TSPATH}"
        export PAGER='nvim +Man!'
      '';
      shellAliases = {
        svi = "sudo -E -s nvim";
        sgit = "sudo -E -s git";
      };
    };
  };
}
