local agenda_path = vim.fn.expand("~/.local/share/nvim-org/")
local _ = vim.fn.system("mkdir -p " .. agenda_path)

require("orgmode").setup({
	org_agenda_files = { agenda_path .. "*.org" },
	org_default_notes_file = agenda_path .. "refile.org",
	org_todo_keywords = { "TODO(t)", "DOING(n)", "|", "DONE(d)", "DELEGATED(o)", "CANCELLED(c)" },
	org_agenda_custom_commands = {
		l = {
			description = "local agenda",
			types = {
				{
					type = "agenda",
					org_agenda_overriding_header = "Local agenda",
					org_agenda_files = { vim.fn.expand("%:p") },
				},
			},
		},
	},
})

vim.cmd([[
  highlight @org.keyword.done guifg=#50fa7b gui=bold
]])

-- Define a highlight group for DOING
vim.api.nvim_set_hl(0, "OrgKeywordDoing", { fg = "#fab387", bold = true })

-- Match the word 'DOING' in Org files and apply the group
vim.api.nvim_create_autocmd("FileType", {
	pattern = "org",
	callback = function()
		vim.fn.matchadd("OrgKeywordDoing", [[\<DOING\>]])
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "orgagenda",
	callback = function()
		vim.fn.matchadd("OrgKeywordDoing", [[\<DOING\>]])
	end,
})

vim.api.nvim_create_user_command("OrgOpenFolder", function()
	vim.cmd("tabnew") -- open new tab
	vim.cmd("cd " .. agenda_path) -- set working directory
	vim.cmd("Oil " .. agenda_path) -- open oil.nvim explorer there
end, { desc = "Open org agenda folder in new tab with oil.nvim" })

vim.keymap.set("n", "<leader>ol", ":OrgOpenFolder<CR>", { desc = "Open org agenda folder (oil.nvim)" })
