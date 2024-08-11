require("nvim-treesitter.configs").setup({
	ensure_installed = {},
	auto_install = false,
	highlight = { enable = true },
	indent = { enable = true },
})
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
