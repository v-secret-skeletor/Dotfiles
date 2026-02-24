-- Disable netrw plugin (recommended when using yazi)
vim.g.loaded_netrwPlugin = 1

require("yazi").setup({
	open_for_directories = true,
	keymaps = {
		copy_relative_path_to_selected_files = "<c-y>",
		open_file_in_vertical_split = "<c-v>",
		open_file_in_horizontal_split = "<c-x>",
		grep_in_directory = "<c-f>",
	},
	integrations = {
		grep_in_directory = "snacks.picker",
		grep_in_selected_files = "snacks.picker",
		picker_add_copy_relative_path_action = "snacks.picker",
	},
})

vim.keymap.set({ "n", "v" }, "<leader>m", "<cmd>Yazi<cr>", { desc = "Open yazi at the current file" })
vim.keymap.set("n", "<leader>cw", "<cmd>Yazi cwd<cr>", { desc = "Open file manager in nvim's cwd" })
vim.keymap.set("n", "<c-up>", "<cmd>Yazi prev<cr>", { desc = "Resume last yazi session" })
