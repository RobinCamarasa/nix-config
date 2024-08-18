{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    ../features/atuin.nix
    ../features/yazi.nix
    ../features/starship.nix
    ../features/direnv.nix
    ../features/nvim/nvim.nix
    ../features/tmux/tmux.nix
    ../features/git.nix
    ../features/bash.nix
    ../features/zoxide.nix
  ];
  options = {
    bd.dev.enable = lib.mkEnableOption "enables dev";
  };
  config = {
    ft.yazi.enable = lib.mkDefault config.bd.dev.enable;
    ft.starship.enable = lib.mkDefault config.bd.dev.enable;
    ft.direnv.enable = lib.mkDefault config.bd.dev.enable;
    ft.nvim.enable = lib.mkDefault config.bd.dev.enable;
    ft.tmux.enable = lib.mkDefault config.bd.dev.enable;
    ft.tmux.main = lib.mkDefault false;
    ft.git.enable = lib.mkDefault config.bd.dev.enable;
    ft.bash.enable = lib.mkDefault config.bd.dev.enable;
    ft.zoxide.enable = lib.mkDefault config.bd.dev.enable;
    ft.atuin.enable = lib.mkDefault config.bd.dev.enable;
  };
}
