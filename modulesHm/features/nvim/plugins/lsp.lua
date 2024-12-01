--[[ vim simple extensions ]]
-- vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
--
-- [[ vim lsp keymap ]]

require("which-key").add({
	{ "<leader>l", group = "[L]SP" },
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

	-- -- The following two autocommands are used to highlight references of the
	-- -- word under your cursor when your cursor rests there for a little while.
	-- --    See `:help CursorHold` for information about when this is executed
	-- --
	-- -- When you move your cursor, the highlights will be cleared (the second autocommand).
	-- local client = vim.lsp.get_client_by_id(event.data.client_id)
	-- if client and client.server_capabilities.documentHighlightProvider then
	--   vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
	--     buffer = event.buf,
	--     callback = vim.lsp.buf.document_highlight,
	--   })
	--
	--   vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
	--     buffer = event.buf,
	--     callback = vim.lsp.buf.clear_references,
	--   })
	-- end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- require('neodev').setup()
require("lspconfig").lua_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "lua-lsp" },
	-- root_dir = function()
	-- 	return vim.loop.cwd()
	-- end,
	-- settings = {
	-- 	Lua = {
	-- 		workspace = { checkThirdParty = false },
	-- 		telemetry = { enable = false },
	-- 	},
	-- }
})

require("lspconfig").pyright.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

require("lspconfig").htmx.setup({
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

--
-- require('lspconfig').rnix.setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
-- }
