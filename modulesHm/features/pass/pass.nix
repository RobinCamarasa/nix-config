{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    ft.pass.enable = lib.mkEnableOption "enables pass";
  };
  config = {
    programs.gpg.enable = config.ft.pass.enable;
    home.packages = lib.mkIf config.ft.pass.enable [
      pkgs.fzf
      pkgs.wl-clipboard
      (pkgs.writeShellScriptBin "tpass" (builtins.readFile ./tpass.sh))
    ];

    programs.password-store = {
      enable = config.ft.pass.enable;
      settings = lib.mkIf config.ft.pass.enable { PASSWORD_STORE_DIR = "$HOME/.password-store"; };
    };

    # Might need gpgconf --reload gpg-agent
    # https://github.com/NixOS/nixpkgs/issues/35464
    services.gpg-agent = lib.mkIf config.ft.pass.enable {
      enable = true;
      defaultCacheTtl = 34560000;
      maxCacheTtl = 34560000;
      enableScDaemon = false;
      pinentryPackage = pkgs.pinentry-gnome3;
    };
  };
}
