require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~|" },
	},
	current_line_blame = true,
})

vim.keymap.set("n", "<leader>dT", function()
	vim.cmd.Gitsigns("diffthis")
end, { desc = "Gitsigns Diff" })
vim.keymap.set("n", "<leader>b", function()
	vim.cmd.Gitsigns("blame_line")
end, { desc = "Gitsigns Toggle Current Line Blame" })
vim.keymap.set("n", "<leader>B", function()
	vim.cmd.Gitsigns("blame")
end, { desc = "Gitsigns Blame" })
