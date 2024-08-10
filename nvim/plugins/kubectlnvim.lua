-- Lualine
require("kubectl").setup()
vim.keymap.set("n", "<leader>k", require("kubectl").open, { noremap = true, silent = true, desc = "[k]ubectl" })
