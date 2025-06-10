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
      default = "robin.camarasa@gmail.com";
      type = pkgs.lib.types.str;
      description = "set git userEmail";
    };
    ft.git.userName = lib.mkOption {
      default = "RobinCamarasa";
      type = pkgs.lib.types.str;
      description = "set git userName";
    };
  };
  config = {
    programs.git = lib.mkIf config.ft.git.enable {
      enable = true;
      userEmail = config.ft.git.userEmail;
      userName = config.ft.git.userName;
      ignores = [ ".envrc" ];
      aliases = {
        lg = "log --graph --all";
        rmt = "remote -v";
        url = "!f() { git remote -v | head -n1 | awk '{print $2}' | sed  -e 's#\.git$##g' -e 's#:#/#g' -e 's#^git@#https://#' -e 's#ci.tno.nl#ci.tno.nl/gitlab#'| head -n1 | tee >(wl-copy); }; f";
      };
      extraConfig = {
        push.autoSetupRemote = true;
        pull.rebase = false;
        safe.directory = "/etc/nixos";
      };
    };
  };
}
