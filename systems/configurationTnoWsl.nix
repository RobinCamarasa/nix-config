# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = "camarasaryr";

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
  environment.systemPackages = with pkgs; [
    # CLI
    ## Essentials
    wget
    html-xml-utils
    gparted
    dust
    tldr
    fzf
    man-pages
    ## Parsing
    jq
    yq
    ## Other
    qrencode
    pandoc
    poppler_utils
    pre-commit
    rustfmt
    kubernetes-helm
    sshfs

    # TUI
    btop
    presenterm
    k9s

    # GUI
    ## Design
    inkscape-with-extensions
    gimp
    ## Media
    sxiv
    zathura

    # Dev
    ## Tools
    gh
    glab
    kubectl
    ## C
    gnumake
    gcc
    gdb
    ## Dhall
    dhall
    dhall-json
    dhall-yaml
    ## Java
    jdk8
    ## Go
    go
    ## Rust
    cargo
    cargo-watch
    rustup
    rust-analyzer
    ## Haskell
    ghc
    ## Python
    poetry
    stdenv.cc.cc.lib
    zlib # numpy
    python3
    ## Latex
    texliveFull
    ## js
    bun
    ## sql
    postgresql
  ];

  # Set user
  security.sudo.extraRules = [
    {
      users = [ "camarasaryr" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
        }
      ];
    }
  ];

  users.users = {
    camarasaryr = {
      isNormalUser = true;
      description = "camarasaryr";
      extraGroups = [
        "wheel"
        "docker"
      ];
      packages = with pkgs; [ ];
    };
    nixos = {
      isNormalUser = true;
      description = "nixos";
      extraGroups = [
        "wheel"
      ];
      packages = with pkgs; [ ];
    };
  };

  virtualisation.docker.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    users = {
      "camarasaryr" = import ../homes/homeTnoWsl.nix;
    };
  };
}
