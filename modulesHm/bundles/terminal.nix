{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    ../features/yazi.nix
    ../features/starship.nix
    ../features/direnv.nix
    ../features/nvim/nvim.nix
    ../features/tmux/tmux.nix
    ../features/git.nix
    ../features/bash.nix
  ];
  ft.yazi.enable = lib.mkDefault true;
  ft.starship.enable = lib.mkDefault true;
  ft.direnv.enable = lib.mkDefault true;
  ft.nvim.enable = lib.mkDefault true;
  ft.tmux.enable = lib.mkDefault true;
  ft.tmux.main = lib.mkDefault false;
  ft.git.enable = lib.mkDefault true;
  ft.bash.enable = lib.mkDefault true;
}
