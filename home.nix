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
  };

  imports = [
    ./modulesHm/bundles/auth.nix
    ./modulesHm/bundles/gui.nix
    ./modulesHm/bundles/terminal.nix
  ];
  ft.bash.TSPATH = "~/repo/:/etc/nixos";
  ft.tmux.main = true;

  programs.home-manager.enable = true;
}
