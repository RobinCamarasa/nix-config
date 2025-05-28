require("which-key").add({
	{ "<leader>g", group = "[g]it" },
})

vim.keymap.set("n", "<leader>gc", "<CMD>Git commit<CR>", { desc = "[g]it [c]ommit" })
vim.keymap.set("n", "<leader>ga", "<CMD>Git add %<CR>", { desc = "[g]it [a]dd current buffer" })
