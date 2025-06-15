{
  config,
  pkgs,
  inputs,
  ...
}:
let
  hlp = import ../utils/helpers.nix { inherit inputs; };
in
{
  home = hlp.main.makeHome { username = "robincamarasa"; };

  imports = [ ../modulesHm/default.nix ];
  ft.bash.TSPATH = "${config.home.homeDirectory}/repo/:/etc/nixos";
  ft.bash.NGPATH = "${config.home.homeDirectory}/repo/";
  ft.tmux.main = true;

  ft.ncspot.enable = false;

  programs.home-manager.enable = true;
}
