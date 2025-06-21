{
  pkgs,
  lib,
  config,
  ...
}:

{
  options = {
    ft.scripts.enable = lib.mkEnableOption "Enable personal scripts";
  };

  config = {
    home.packages = lib.mkIf config.ft.kubectl.enable [
      pkgs.fzf
      (pkgs.writers.writeBashBin "@qn" { } (builtins.readFile ./qn.sh))
    ];

    programs.bash.sessionVariables = lib.mkIf (config.ft.scripts.enable && config.ft.bash.enable) (
      lib.mkAfter {
        QNTEST = "hello";
      }
    );
  };
}
