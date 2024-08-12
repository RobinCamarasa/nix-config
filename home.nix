{
  config,
  pkgs,
  inputs,
  ...
}:
let
  hlp = import ./utils/helpers.nix { inherit inputs; };
in
{
  home = hlp.main.makeHome {
    username = "robincamarasa";
    file = { };
    packages = with pkgs; [
      neofetch
      gcc
      (writeShellScriptBin "vimclip" (builtins.readFile ./scripts/shell/vimclip.sh))
      (writers.writeBashBin "ts" { } (builtins.readFile ./scripts/shell/ts.sh))
    ];
  };

  imports = [
    ./modulesHm/bundles/auth.nix
    ./modulesHm/bundles/gui.nix
    ./modulesHm/bundles/terminal.nix
  ];
  ft.bash.TSPATH = "~/repo/:/etc/nixos";

  programs.home-manager.enable = true;
}
