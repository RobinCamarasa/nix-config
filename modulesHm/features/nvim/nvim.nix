{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  hlp = import ./../../../utils/helpers.nix { inherit inputs; };
in
{
  options = {
    ft.nvim.enable = lib.mkEnableOption "enables neovim";
  };
  config = lib.mkIf config.ft.nvim.enable {

    nixpkgs.overlays = [
      (hlp.vim.makeOverlay [
        "gitsigns"
        "kubectlnvim"
        "whichkey"
      ])
    ];
    programs.neovim = {
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
        ${builtins.readFile ./vim-basic.lua}
      '';
      plugins = with pkgs.vimPlugins; [
        {
          plugin = own-whichkey;
          config = hlp.vim.toLuaFile ./plugins/which-key.lua;
        }
        {
          plugin = nvim-cmp;
          config = hlp.vim.toLuaFile ./plugins/nvim-cmp.lua;
        }
        neodev-nvim # LSP essential
        cmp-nvim-lsp # LSP essential
        {
          plugin = nvim-lspconfig;
          config = hlp.vim.toLuaFile ./plugins/lsp.lua;
        }
        {
          plugin = conform-nvim;
          config = hlp.vim.toLuaFile ./plugins/conform.lua;
        }

        {
          plugin = tokyonight-nvim;
          config = "colorscheme tokyonight-night";
        }
        nvim-web-devicons
        {
          plugin = telescope-fzf-native-nvim;
          config = hlp.vim.toLuaFile ./plugins/telescope.lua;
        }
        {
          plugin = telescope-symbols-nvim;
          config = hlp.vim.toLuaFile ./plugins/telescope-symbols.lua;
        }
        vim-sleuth
        {
          plugin = own-kubectlnvim;
          config = hlp.vim.toLuaFile ./plugins/kubectlnvim.lua;
        }
        {
          plugin = mini-nvim;
          config = hlp.vim.toLuaFile ./plugins/mini-nvim.lua;
        }
        {
          plugin = oil-nvim;
          config = hlp.vim.toLuaFile ./plugins/nvim-oil.lua;
        }
        {
          plugin = own-gitsigns;
          config = hlp.vim.toLuaFile ./plugins/gitsigns.lua;
        }
        {
          plugin = vim-fugitive;
          config = hlp.vim.toLuaFile ./plugins/vim-fugitive.lua;
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
          config = hlp.vim.toLuaFile ./plugins/nvim-treesitter.lua;
        }
        plenary-nvim
      ];
    };
  };
}
