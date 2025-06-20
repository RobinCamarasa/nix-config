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
    home.packages = [ (pkgs.writeShellScriptBin "vimclip" (builtins.readFile ./sh/vimclip.sh)) ];

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraPackages = with pkgs; [
        # dhall
        dhall-lsp-server

        # Nix
        nixfmt-rfc-style
        nixd

        # Lua
        luajitPackages.lua-lsp

        # Rust
        rust-analyzer
        rustfmt
        lldb_18

        # go
        gopls
        delve

        # Python
        basedpyright
        stylua
        isort
        black

        # Haskell
        ormolu
        haskell-language-server

        # typescript
        typescript
        typescript-language-server

        # vue
        vue-language-server

        # other
        xclip
        wl-clipboard
        ripgrep
        fd
      ];
      extraLuaConfig = ''
        ${builtins.readFile ./vim-basic.lua}
      '';
      plugins = with pkgs.vimPlugins; [
        {
          plugin = which-key-nvim;
          config = hlp.vim.toLuaFile ./plugins/which-key.lua;
        }
        {
          plugin = nvim-cmp;
          config = hlp.vim.toLuaFile ./plugins/nvim-cmp.lua;
        }
        vim-dadbod
        vim-dadbod-ui
        rest-nvim
        {
          plugin = harpoon2;
          config = hlp.vim.toLuaFile ./plugins/nvim-harpoon.lua;
        }
        neodev-nvim # LSP essential
        cmp-nvim-lsp # LSP essential
        {
          plugin = nvim-lspconfig;
          config = hlp.vim.toLuaFile ./plugins/lsp.lua;
        }

        nvim-nio
        nvim-dap-ui
        nvim-dap-virtual-text
        nvim-dap-go
        nvim-dap-python
        {
          plugin = nvim-dap;
          config = hlp.vim.toLuaFile ./plugins/nvim-dap.lua;
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
        telescope-ui-select-nvim
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
          plugin = mini-nvim;
          config = hlp.vim.toLuaFile ./plugins/mini-nvim.lua;
        }
        {
          plugin = oil-nvim;
          config = hlp.vim.toLuaFile ./plugins/nvim-oil.lua;
        }
        {
          plugin = gitsigns-nvim;
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
              p.tree-sitter-roc
              p.tree-sitter-dhall
              p.tree-sitter-go
              p.tree-sitter-c
              p.tree-sitter-haskell
              p.tree-sitter-typescript
              p.tree-sitter-vue
            ])
          );
          config = hlp.vim.toLuaFile ./plugins/nvim-treesitter.lua;
        }
        plenary-nvim

        {
          plugin = orgmode;
          config = hlp.vim.toLuaFile ./plugins/nvim-orgmode.lua;
        }
      ];
    };
  };
}
