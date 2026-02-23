require("todo-comments").setup()
require("snacks").setup({
	bigfile = { enabled = true },
	dashboard = {
		enabled = true,
		sections = {
			{ section = "header" },
			{ section = "keys", gap = 1, padding = 1 },
			{ pane = 2, icon = " ", title = "Sessions", section = "session", indent = 2, padding = 1 },
			{ pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
			{ pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
			{
				pane = 2,
				icon = " ",
				title = "Git Status",
				section = "terminal",
				enabled = function()
					return Snacks.git.get_root() ~= nil
				end,
				cmd = "git status --short --branch --renames",
				height = 5,
				padding = 1,
				ttl = 5 * 60,
				indent = 3,
			},
		},
	},
	gh = {},
	gitbrowse = {},
	picker = {
		enabled = true,
		win = {
			input = {
				keys = {
					["<C-,>"] = { "flash", mode = { "n", "i" } },
					["s"] = { "flash" },
				},
			},
		},
		actions = {
			flash = function(picker)
				require("flash").jump({
					pattern = "^",
					label = { after = { 0, 0 } },
					search = {
						mode = "search",
						exclude = {
							function(win)
								return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
							end,
						},
					},
					action = function(match)
						local idx = picker.list:row2idx(match.pos[1])
						picker.list:_move(idx, true, true)
					end,
				})
			end,
		},
	},
	scratch = { enabled = true },
	statuscolumn = {
		enabled = true,
		left = { "mark", "sign" }, -- priority of signs on the left (high to low)
		right = { "fold", "git" }, -- priority of signs on the right (high to low)
		folds = {
			open = true, -- show open fold icons
			git_hl = true, -- use Git Signs hl for fold icons
		},

		git = {
			patterns = { "GitSign", "MiniDiffSign" }, -- patterns to match Git signs
		},
		refresh = 50, -- refresh at most every 50ms
	},
})

-- Manually set statuscolumn since it's nested under opts
vim.o.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]

vim.keymap.set("n", "<leader>go", function()
	Snacks.gitbrowse.open()
end, { desc = "Snacks GitBrowse" })

local bufOpts = {
	nofile = true,
	win = {
		input = {
			keys = {
				["<c-d>"] = { "bufdelete", mode = { "n", "i" } },
				["<c-x>"] = { "edit_split", mode = { "n", "i" } },
			},
		},
	},
}
-- vim.keymap.set("n", ";", function()
-- 	Snacks.picker.buffers(bufOpts)
-- end, { desc = "Snacks Picker Buffers" })

vim.keymap.set("n", "<leader>f", function()
	Snacks.picker.grep()
end, { desc = "Snacks finder" })

vim.keymap.set("n", "<leader>gd", function()
	Snacks.picker.lsp_definitions()
end, { desc = "Snacks Picker LSP definition" })

vim.keymap.set("n", "<leader>gr", function()
	Snacks.picker.lsp_references()
end, { desc = "Snacks Picker LSP references" })

vim.keymap.set("n", "<leader>gi", function()
	Snacks.picker.gh_issue()
end, { desc = "Snacks Picker LSP implementations" })

vim.keymap.set("n", "<leader>gp", function()
	Snacks.picker.gh_pr()
end, { desc = "Snacks Picker LSP implementations" })

vim.keymap.set("n", "<leader>ds", function()
	Snacks.picker.lsp_symbols()
end, { desc = "Snacks Picker Document Symbols" })

vim.keymap.set("n", "<leader>ws", function()
	Snacks.picker.lsp_workspace_symbols()
end, { desc = "Snacks Picker Workspace Symbols" })

vim.keymap.set("n", "<leader>ts", function()
	Snacks.picker.treesitter()
end, { desc = "Snacks Picker Treesitter Symbols" })

vim.keymap.set("n", "<leader>qf", function()
	Snacks.picker.qflist()
end, { desc = "Snacks Picker Quickfix" })

vim.keymap.set("n", "<leader>km", function()
	Snacks.picker.keymaps()
end, { desc = "Snacks Picker Keymaps" })

vim.keymap.set("n", "<C-z>", function()
	Snacks.picker.undo()
end, { desc = "Snacks Picker Undo History" })

vim.keymap.set("n", "<leader>u", function()
	Snacks.picker.undo()
end, { desc = "Snacks Picker Undo History" })

vim.keymap.set("n", "<leader>j", function()
	Snacks.picker.jumps()
end, { desc = "Snacks Picker Jumplist" })

vim.keymap.set("n", "<leader>xx", function()
	Snacks.picker.diagnostics()
end, { desc = "Snacks Picker Diagnostics" })

vim.keymap.set("n", "<leader>xX", function()
	Snacks.picker.diagnostics_buffer()
end, { desc = "Snacks Picker Diagnostics Buffer" })

vim.keymap.set("n", "<leader>tl", function()
	Snacks.picker.todo_comments()
end, { desc = "Snacks Picker Todo_comments" })
