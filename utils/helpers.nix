{ inputs }:
{
  vim = rec {
    addPlugin = prev: name: {
      "own-${name}" = prev.vimUtils.buildVimPlugin {
        name = "${name}";
        src = inputs."plugin-${name}";
      };
    };
    makePluginList = prev: builtins.foldl' (a: b: a // (addPlugin prev b)) prev.vimPlugins;
    makeOverlay = plugins: (final: prev: { vimPlugins = makePluginList prev plugins; });
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
  };
  main = {
    makeHome =
      { username, ... }@ins:
      {
        homeDirectory = "/home/${username}";
        stateVersion = "24.05";
        sessionVariables.EDITOR = "nvim";
      }
      // ins;
  };
}
