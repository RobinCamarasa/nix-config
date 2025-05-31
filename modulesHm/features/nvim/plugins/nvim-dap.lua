local dap = require("dap")
local ui = require("dapui")

require("dapui").setup()
require("dap-go").setup()
require("dap-python").setup()

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

vim.keymap.set("n", "<space>ab", dap.toggle_breakpoint, { desc = "d[a]p toggle [b]reakpoint" })
vim.keymap.set("n", "<space>ac", dap.run_to_cursor, { desc = "d[a]p run to [c]ursor" })

vim.keymap.set("n", "<leader>aa", function()
	require("dapui").eval(nil, { enter = true })
end, { desc = "d[a]p inspect variable content ([a])" })

require("which-key").add({
	{ "<leader>a", group = "d[a]p" },
})

vim.keymap.set("n", "<leader>aj", dap.continue, { desc = "d[a]p continue ([j])" })
vim.keymap.set("n", "<leader>aJ", dap.step_into, { desc = "d[a]p step into ([J])" })
vim.keymap.set("n", "<leader>al", dap.step_over, { desc = "d[a]p step over ([l])" })
vim.keymap.set("n", "<leader>aL", dap.step_out, { desc = "d[a]p step out ([L])" })
vim.keymap.set("n", "<leader>ah", dap.step_back, { desc = "d[a]p step back ([h])" })
vim.keymap.set("n", "<leader>ar", dap.restart, { desc = "d[a]p [r]estart" })
vim.keymap.set("n", "<leader>aq", dap.disconnect, { desc = "d[a]p [q]uit" })

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

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values

local function pick_executable(callback)
	pickers
		.new({}, {
			prompt_title = "Pick Executable",
			finder = finders.new_oneshot_job(
				{ "find", "./target/debug", "-type", "f", "-perm", "/111" }, -- find executable files
				{ cwd = vim.fn.getcwd() }
			),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					callback(selection[1])
				end)
				return true
			end,
		})
		:find()
end

dap.adapters.lldb = {
	type = "executable",
	command = "lldb-dap",
	name = "lldb",
}

dap.configurations.rust = {
	{
		name = "Launch with lldb-dap",
		type = "lldb",
		request = "launch",
		program = function()
			return coroutine.create(function(dap_coro)
				pick_executable(function(file)
					coroutine.resume(dap_coro, file)
				end)
			end)
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},

		-- 💡 Optional: for Rust, use these:
		runInTerminal = false,
		env = function()
			local variables = {}
			for k, v in pairs(vim.fn.environ()) do
				table.insert(variables, string.format("%s=%s", k, v))
			end
			return variables
		end,
	},
}
