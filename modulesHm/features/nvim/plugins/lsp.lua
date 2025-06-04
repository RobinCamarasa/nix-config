require("which-key").add({
	{ "<leader>l", group = "[l]sp" },
})
--

local on_attach = function(_, bufnr)
	local bufmap = function(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	bufmap("K", vim.lsp.buf.hover, "Hover Documentation")
	bufmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
	bufmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	bufmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
	bufmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	bufmap("<leader>la", vim.lsp.buf.code_action, "Code [A]ction")
	bufmap("<leader>ld", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
	bufmap("<leader>ls", require("telescope.builtin").lsp_document_symbols, "Document [S]ymbols")
	bufmap("<leader>lr", vim.lsp.buf.rename, "[R]ename")

	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, {})
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

require("lspconfig").lua_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "lua-lsp" },
})

require("lspconfig").basedpyright.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

require("lspconfig").rust_analyzer.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		["rust-analyzer"] = {
			diagnostics = {
				enable = false,
			},
		},
	},
})

require("lspconfig").nixd.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

require("lspconfig").dhall_lsp_server.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

require("lspconfig").gopls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

require("lspconfig").hls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

local vue_ls_path = vim.fn.resolve(vim.fn.exepath("vue-language-server"))
vue_ls_path = vim.fn.fnamemodify(vue_ls_path, ":h:h") .. "/lib/node_modules/@vue/language-server"

require("lspconfig").ts_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,

	init_options = {
		plugins = {
			{
				name = "@vue/typescript-plugin",
				location = vue_ls_path,
				languages = { "vue" },
			},
		},
	},
	filetypes = {
		"javascript",
		"typescript",
		"vue",
	},
})
