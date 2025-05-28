local dap = require("dap")
local ui = require("dapui")

require("dapui").setup()
require("dap-go").setup()

require("nvim-dap-virtual-text").setup()

-- Handled by nvim-dap-go
dap.adapters.go = {
	type = "server",
	port = "${port}",
	executable = {
		command = "dlv",
		args = { "dap", "-l", "127.0.0.1:${port}" },
	},
}

vim.keymap.set("n", "<space>ab", dap.toggle_breakpoint)
vim.keymap.set("n", "<space>ac", dap.run_to_cursor)

-- Eval var under cursor
vim.keymap.set("n", "<leader>aa", function()
	require("dapui").eval(nil, { enter = true })
end)

vim.keymap.set("n", "<leader>aj", dap.continue)
vim.keymap.set("n", "<leader>aJ", dap.step_into)
vim.keymap.set("n", "<leader>al", dap.step_over)
vim.keymap.set("n", "<leader>aL", dap.step_out)
vim.keymap.set("n", "<leader>ah", dap.step_back)
vim.keymap.set("n", "<leader>ar", dap.restart)
vim.keymap.set("n", "<leader>aq", dap.disconnect)

dap.listeners.before.attach.dapui_config = function()
	ui.open()
end
dap.listeners.before.launch.dapui_config = function()
	ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	ui.close()
end
