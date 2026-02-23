require("toggleterm").setup({
	size = 20,
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	terminal_mappings = true,
	persist_size = true,
	direction = "horizontal",
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved",
		winblend = 0,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
})

-- map leader st to TermSelect
vim.keymap.set("n", "<leader>st", ":TermSelect<CR>", { desc = "Terminal select" })
-- set terminal names
vim.keymap.set("n", "<leader>rt", ":ToggleTermSetName<CR>", { desc = "Terminal rename" })
-- map leader tt to Toggleterm
vim.keymap.set("n", "<leader>tt", ":ToggleTerm<CR>", { desc = "Terminal toggle" })
vim.keymap.set("n", "<leader>nt", ":TermNew<CR>", { desc = "Terminal new" })
