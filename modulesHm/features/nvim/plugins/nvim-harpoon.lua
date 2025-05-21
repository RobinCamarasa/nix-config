local harpoon = require("harpoon")

require("which-key").add({
	{ "<leader>h", group = "[h]arpoon" },
})

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>ha", function()
	harpoon:list():add()
end, { desc = "[h]arpoon [a]dd current buffer" })
vim.keymap.set("n", "<leader>hm", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "[h]arpoon [m]enu list files" })

vim.keymap.set("n", "<leader>hh", function()
	harpoon:list():select(1)
end, { desc = "[h]arpoon first ([h]) item" })
vim.keymap.set("n", "<leader>hj", function()
	harpoon:list():select(2)
end, { desc = "[h]arpoon second ([j]) item" })
vim.keymap.set("n", "<leader>hk", function()
	harpoon:list():select(3)
end, { desc = "[h]arpoon third ([k]) item" })
vim.keymap.set("n", "<leader>hl", function()
	harpoon:list():select(4)
end, { desc = "[h]arpoon forth ([l]) item" })
