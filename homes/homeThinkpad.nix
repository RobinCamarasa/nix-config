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
  ft.bash.TSPATH = "~/repo/:/etc/nixos";
  ft.tmux.main = true;

  ft.ncspot.enable = false;

  programs.home-manager.enable = true;
}
