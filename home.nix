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
      gnomeExtensions.emoji-copy
      gnomeExtensions.unite
      pinentry-gnome3
      (writeShellScriptBin "tpass" (builtins.readFile ./scripts/shell/tpass.sh))
      (writeShellScriptBin "vimclip" (builtins.readFile ./scripts/shell/vimclip.sh))
      (writers.writeBashBin "ts" { } (builtins.readFile ./scripts/shell/ts.sh))

    ];
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

  imports = [
    ./modulesHm/bundles/terminal.nix
    ./modulesHm/bundles/auth.nix
  ];
  ft.bash.TSPATH = "~/repo/:/etc/nixos";

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  dconf = {
    settings = {
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
