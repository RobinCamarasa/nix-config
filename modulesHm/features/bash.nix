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
    home.packages = lib.mkIf config.ft.bash.enable [ pkgs.neofetch ];
    programs.bash = lib.mkIf config.ft.bash.enable {
      enable = true;
      enableCompletion = true;
      bashrcExtra = ''
        export PATH="$PATH:./"
        clear
        neofetch
        export TSPATH="${config.ft.bash.TSPATH}"
        export LD_LIBRARY_PATH="${pkgs.zlib.outPath}/lib:$LD_LIBRARY_PATH" # numpy
        export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib.outPath}/lib:$LD_LIBRARY_PATH" # numpy
      '';
      shellAliases = {
        svi = "sudo -E -s nvim";
        sgit = "sudo -E -s git";
      };
    };
  };
}
