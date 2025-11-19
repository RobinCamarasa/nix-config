{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    ft.gnome.enable = lib.mkEnableOption "enables gnome";
  };
  config = lib.mkIf config.ft.gnome.enable {
    home.packages = with pkgs; [
      gnomeExtensions.emoji-copy
      gnomeExtensions.unite
      pinentry-gnome3
    ];

    dconf = {
      settings = {
        "org/gnome/shell/app-switcher" = {
          current-workspace-only = true;
        };
        "org.gnome.settings-daemon.plugins" = {
          "color night-light-enabled" = true;
          "color night-light-schedule-from" = 0.01;
          "color night-light-schedule-to" = 23.99;
        };

        "org/gnome/desktop/peripherals/pointingstick" = {
          accel-profile = "adaptive";
          speed = 0.6;
        };

        "org/gnome/desktop/peripherals/mouse" = {
          accel-profile = "adaptive";
          speed = 0.6;
          click-method = "areas";
        };

        "org.gnome.desktop.peripherals.touchpad" = {
          accel-profile = "adaptive";
          speed = 0.6;
          click-method = "areas";
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
  };
}
