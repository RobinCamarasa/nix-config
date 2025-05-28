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
  home = hlp.main.makeHome { username = "camarasaryr"; };

  imports = [ ../modulesHm/default.nix ];
  bd.gui.enable = false;

  ft.bash.TSPATH = "~/repo/:/etc/nixos";
  ft.tmux.main = true;

  ft.ncspot.enable = false;

  programs.home-manager.enable = true;
}
