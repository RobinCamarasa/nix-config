local uv = vim.loop

local remote = os.getenv("ORG_REMOTE")
local mountpoint = os.getenv("ORG_MOUNTPOINT") or vim.fn.expand("~/.local/share/nvim-org")

if remote then
	os.execute("mkdir -p " .. mountpoint)

	local function is_mounted(path)
		local result = os.execute("mountpoint -q " .. path)
		return result == true or result == 0
	end

	if not is_mounted(mountpoint) then
		local cmd = string.format("sshfs %s %s -o reconnect", remote, mountpoint)
		uv.spawn("sh", { args = { "-c", cmd } }, function(code)
			if code == 0 then
				print("[sshfs] Mounted " .. remote .. " at " .. mountpoint)
			else
				print("[sshfs] Failed to mount " .. remote .. " at " .. mountpoint)
			end
		end)
	else
		print("[sshfs] Already mounted at " .. mountpoint)
	end
else
	print("[sshfs] ORG_REMOTE not set, skipping sshfs mount")
end

local agenda_path = mountpoint .. "/"

-- Proceed with orgmode setup using agenda_path as usual

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
	vim.cmd("lcd " .. agenda_path)
	vim.cmd("Oil " .. agenda_path)
end, { desc = "Open org agenda folder in new tab with oil.nvim" })

vim.keymap.set("n", "<leader>ol", ":tabnew<CR>:OrgOpenFolder<CR>", { desc = "Open org agenda folder" })
