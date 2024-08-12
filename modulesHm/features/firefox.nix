{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  options = {
    ft.firefox.enable = lib.mkEnableOption "enables firefox";
  };
  config = {
    programs.firefox = lib.mkIf config.ft.firefox.enable {
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
  };
}
