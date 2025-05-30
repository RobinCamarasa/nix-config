{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configurationThinkpad.nix
    inputs.home-manager.nixosModules.default
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.cleanOnBoot = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;

  time.timeZone = "Europe/Amsterdam";

  i18n.defaultLocale = "en_IN";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.ollama.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  # Configure console keymap
  console.keyMap = "us-acentos";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  security.sudo.extraRules = [
    {
      users = [ "robincamarasa" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
        }
      ];
    }
  ];
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.robincamarasa = {
    isNormalUser = true;
    description = "RobinCamarasa";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Fonts
    nerd-fonts.inconsolata

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
    qrencode
    pandoc
    poppler_utils
    ## Services
    tailscale

    # TUI
    btop
    presenterm
    k9s

    # GUI
    ## Clipboard
    wl-clipboard
    ## Documents
    libreoffice-qt
    ## Design
    inkscape-with-extensions
    gimp
    ## Media
    vlc
    sxiv
    ## Browser
    brave
    ## Sound
    helvum

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
    python3
    ## Latex
    texliveFull
    ## js
    bun

    # Virtualization
    qemu
    quickemu
  ];

  programs.java = {
    enable = true;
    package = pkgs.jre8;
  };

  virtualisation.docker.enable = true;
  services.openssh.enable = true;
  services.tailscale.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "25.05"; # Did you read the comment?

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    users = {
      "robincamarasa" = import ../homes/homeThinkpad.nix;
    };
  };
}
