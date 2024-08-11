{
  config,
  pkgs,
  inputs,
  ...
}:

{
  nixpkgs = {
    overlays = [
      (final: prev: {
        vimPlugins = prev.vimPlugins // {
          own-gitsigns = prev.vimUtils.buildVimPlugin {
            name = "gitsigns";
            src = inputs.plugin-gitsigns;
          };
          own-whichkey = prev.vimUtils.buildVimPlugin {
            name = "whichkey";
            src = inputs.plugin-whichkey;
          };
          own-fidget = prev.vimUtils.buildVimPlugin {
            name = "fidget";
            src = inputs.plugin-fidget;
          };
          own-kubectlnvim = prev.vimUtils.buildVimPlugin {
            name = "fidget";
            src = inputs.plugin-kubectlnvim;
          };
        };
      })
    ];
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "robincamarasa";
  home.homeDirectory = "/home/robincamarasa";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.neofetch
    pkgs.gcc
    pkgs.gnomeExtensions.emoji-copy
    pkgs.gnomeExtensions.unite
    pkgs.pinentry-gnome3
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    (pkgs.writeShellScriptBin "tpass" (builtins.readFile ./scripts/shell/tpass.sh))
    (pkgs.writeShellScriptBin "vimclip" (builtins.readFile ./scripts/shell/vimclip.sh))
    (pkgs.writers.writeBashBin "ts" { } (builtins.readFile ./scripts/shell/ts.sh))

  ];

  programs.gpg.enable = true;

  # Might need gpgconf --reload gpg-agent
  # https://github.com/NixOS/nixpkgs/issues/35464
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 34560000;
    maxCacheTtl = 34560000;
    enableScDaemon = false;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  programs.neovim =
    let
      toLua = str: ''
        lua << EOF
        ${str}
        EOF
      '';
      toLuaFile = file: ''
        lua << EOF
        ${builtins.readFile file}
        EOF
      '';
    in
    {
      enable = true;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraPackages = with pkgs; [
        luajitPackages.lua-lsp
        pyright

        nixfmt-rfc-style
        stylua
        isort
        black

        xclip
        wl-clipboard
        ripgrep
      ];
      extraLuaConfig = ''
        ${builtins.readFile ./programs/nvim/vim-basic.lua}
      '';
      plugins = with pkgs.vimPlugins; [
        {
          plugin = own-whichkey;
          config = toLuaFile ./programs/nvim/plugins/which-key.lua;
        }
        {
          plugin = nvim-cmp;
          config = toLuaFile ./programs/nvim/plugins/nvim-cmp.lua;
        }
        neodev-nvim # LSP essential
        cmp-nvim-lsp # LSP essential
        {
          plugin = nvim-lspconfig;
          config = toLuaFile ./programs/nvim/plugins/lsp.lua;
        }
        {
          plugin = conform-nvim;
          config = toLuaFile ./programs/nvim/plugins/conform.lua;
        }

        {
          plugin = tokyonight-nvim;
          config = "colorscheme tokyonight-night";
        }
        nvim-web-devicons
        {
          plugin = telescope-fzf-native-nvim;
          config = toLuaFile ./programs/nvim/plugins/telescope.lua;
        }
        {
          plugin = telescope-symbols-nvim;
          config = toLuaFile ./programs/nvim/plugins/telescope-symbols.lua;
        }
        vim-sleuth
        {
          plugin = own-kubectlnvim;
          config = toLuaFile ./programs/nvim/plugins/kubectlnvim.lua;
        }
        {
          plugin = mini-nvim;
          config = toLuaFile ./programs/nvim/plugins/mini-nvim.lua;
        }
        {
          plugin = oil-nvim;
          config = toLuaFile ./programs/nvim/plugins/nvim-oil.lua;
        }
        {
          plugin = own-gitsigns;
          config = toLuaFile ./programs/nvim/plugins/gitsigns.lua;
        }
        {
          plugin = vim-fugitive;
          config = toLuaFile ./programs/nvim/plugins/vim-fugitive.lua;
        }
        {
          plugin = (
            nvim-treesitter.withPlugins (p: [
              p.tree-sitter-nix
              p.tree-sitter-vim
              p.tree-sitter-bash
              p.tree-sitter-rust
              p.tree-sitter-lua
              p.tree-sitter-python
              p.tree-sitter-json
              p.tree-sitter-yaml
            ])
          );
          config = toLuaFile ./programs/nvim/plugins/nvim-treesitter.lua;
        }
        plenary-nvim
      ];
    };

  programs.git = {
    enable = true;
    userEmail = "robin.camarasa@pm.me";
    userName = "RobinCamarasa";
  };

  programs.tmux = {
    enable = true;
    shortcut = "j";
    keyMode = "vi";
    disableConfirmationPrompt = true;
    extraConfig = ''
      set-option -g default-terminal "screen-256color"
      set -s escape-time 0
      set-option -g default-command "test -f $(pwd)/.tmuxrc && bash --rcfile $(pwd)/.tmuxrc || bash"
      set-option -g allow-rename off
      bind-key C-j send-prefix
      bind-key -n M-l next-window
      bind-key -n M-h previous-window
      bind m split-window ts
      bind-key X if-shell '[ $(tmux list-sessions | wc -l) -ne 1 ]' \
                    "run-shell 'tmux switch-client -n \\\; kill-session -t \"#S\"'" \
                    "run-shell 'tmux kill-session -t \"#S\"'"

      # Style
      set-option -g status-style bg="#088585"
    '';
  };

  programs.firefox = {
    enable = true;
    policies = {
      DefaultDownloadDirectory = "/tmp";
    };
    profiles.default = {
      search.engines = {
        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };
        "Nix Options" = {
          definedAliases = [ "@no" ];
          urls = [
            {
              template = "https://search.nixos.org/options";
              params = [
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
        };
      };
      search.force = true;
      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [ vimium-c ];
    };
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.kitty = {
    enable = true;
    theme = "Tokyo Night";
    settings = {
      enable_audio_bell = false;
      allow_remote_control = "yes";
      hide_window_decorations = "yes";
    };
    font = {
      size = 14;
      name = "Inconsolata Nerd Font";
    };
  };

  programs.zathura = {
    enable = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:./"
      clear
      neofetch
      export TSPATH="/etc/nixos:~/repo"
    '';
    shellAliases = {
      tmux = "tmux -u";
      svi = "sudo -E -s nvim";
    };
  };

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    shellWrapperName = "yy";
  };

  programs.starship = {
    enable = true;
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/robincamarasa/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  dconf = {
    settings = {
      "org/gnome/calculator" = {
        button-mode = "programming";
        show-thousands = true;
        base = 10;
        word-size = 64;
      };
      "org/gnome/shell/app-switcher" = {
        current-workspace-only = true;
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        binding = "<Super>r";
        command = "kitty bash -c 'tpass; kitty @ close-window'";
        name = "tpass";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
        binding = "<Super>t";
        command = "kitty bash -c 'ts; kitty @ close-window'";
        name = "ts";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
        binding = "<Shift><Super>v";
        command = "kitty bash -c 'vimclip; kitty @ close-window'";
        name = "vimclip";
      };
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [ "emoji-copy@felipeftn" ];
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
