{
  pkgs,
  lib,
  config,
  ...
}:

{
  options = {
    ft.kubectl.enable = lib.mkEnableOption "Enable kubectl and related tools";
    ft.kubectl.KUBEFOLDER = lib.mkOption {
      default = "${config.xdg.configHome}/kubectl/";
      type = pkgs.lib.types.str;
      description = "Set the folder containing the kubeconfig files";
    };
  };

  config = {
    home.packages = lib.mkIf config.ft.kubectl.enable [
      pkgs.kubectl
      pkgs.kubectx
    ];

    programs.bash.bashrcExtra = lib.mkIf (config.ft.kubectl.enable && config.ft.bash.enable) (
      lib.mkAfter
        # bash
        ''
          # Set KUBECONFIG to include all YAML files from the specified kube folder
          export KUBEFOLDER="${config.ft.kubectl.KUBEFOLDER}"
          if [ -d "$KUBEFOLDER" ]; then
            files=$(find "$KUBEFOLDER" -type f \( -name '*.yml' -o -name '*.yaml' \))
            if [ -n "$files" ]; then
              export KUBECONFIG=$(echo "$files" | paste -sd ':' -)
            fi
          fi
        ''
    );
    programs.bash.shellAliases = lib.mkIf (config.ft.kubectl.enable && config.ft.bash.enable) (
      lib.mkAfter {
        k = "kubectl";
      }
    );
  };
}
