vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
require("auto-session").setup({
	log_level = "error",
	auto_save = true,
	auto_create = true,
	args_allow_files_autosave = true,
	close_filetypes_on_save = { "checkhealth", "sidekick_terminal", "grug-far", "toggleterm" },
	allowed_dirs = { "/workspaces/*"})
vim.keymap.set("n", "<leader>ss", ":AutoSession save<CR>", { desc = "Save session" })
vim.keymap.set("n", "<leader>sl", ":AutoSession search<CR>", { desc = "Load session" })
