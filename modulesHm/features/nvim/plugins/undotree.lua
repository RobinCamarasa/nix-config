require("which-key").add({
	{ "<leader>u", group = "[u]ndotree" },
})

vim.keymap.set("n", "<leader>ut", vim.cmd.UndotreeToggle, { desc = "[u]ndotree [t]oggle" })
